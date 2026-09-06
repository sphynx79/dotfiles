require 'fileutils'
require 'json'
require 'open3'
require 'timeout'
require 'tmpdir'

root = File.expand_path('..', __dir__)
scratch_root = File.join(Dir.home, '.pi/agent/tmp')
FileUtils.mkdir_p(scratch_root)
scratch = Dir.mktmpdir('screensaver-test.', scratch_root)
log = File.open("#{scratch}/test.log", 'w')
puts "START: screensaver regression test; log: #{log.path}"

begin
  home = "#{scratch}/home"
  bin = "#{scratch}/bin"
  FileUtils.mkdir_p([bin, "#{home}/.local/share/mise/shims",
                    "#{home}/.local/state/hyprarch/toggles"])
  stub = <<~'BASH'
    #!/usr/bin/env bash
    case "${0##*/}" in
      hyprctl)
        printf '%s\n' "$*" >>"$CALLS"
        if [[ $1 == monitors ]]; then
          echo '[{"name":"DP-1","focused":true},{"name":"DP-2","focused":false}]'
        elif [[ $1 == activewindow ]]; then
          echo '{"class":"org.hyprarch.screensaver"}'
        fi
        ;;
      pgrep) exit "${ALREADY_RUNNING:-1}" ;;
      tte)
        [[ $1 == --version ]] && exit 0
        echo "$$" >>"$EFFECTS"
        exec sleep 30
        ;;
    esac
  BASH
  %w[hyprctl walker ghostty pgrep pkill].each do |name|
    File.write("#{bin}/#{name}", stub)
    File.chmod(0o755, "#{bin}/#{name}")
  end
  tte = "#{home}/.local/share/mise/shims/tte"
  File.write(tte, stub)
  File.chmod(0o755, tte)
  env = { 'HOME' => home, 'PATH' => "#{bin}:#{ENV.fetch('PATH')}",
          'CALLS' => "#{scratch}/calls", 'EFFECTS' => "#{scratch}/effects" }

  output, status = Open3.capture2e(env, 'bash', "#{root}/bin/launch-screensaver", 'force')
  raise output unless status.success?
  calls = File.readlines(env['CALLS'])
  launches = calls.grep(/exec_cmd/)
  raise 'Ghostty must launch once per monitor' unless launches.size == 2
  raise 'Ghostty config not isolated' unless launches.all? do |line|
    line.start_with?('eval hl.dispatch(') &&
      line.include?('ghostty --class=org.hyprarch.screensaver') &&
      line.include?('--config-default-files=false') &&
      line.include?("--config-file=#{home}/.config/ghostty/screensaver")
  end
  launches.each_with_index do |line, index|
    raise 'Missing monitor placement rule' unless line.include?("monitor = 'DP-#{index + 1}'")
  end
  calls.each do |line|
    next unless line.start_with?('eval ')

    output, status = Open3.capture2e('luac', '-p', '-', stdin_data: line.delete_prefix('eval '))
    raise output unless status.success?
  end
  log.puts 'CHECKPOINT: Ghostty preferred, isolated config, valid Lua, per-monitor placement'

  File.write(env['CALLS'], '')
  _, status = Open3.capture2e(env.merge('ALREADY_RUNNING' => '0'),
                            'bash', "#{root}/bin/launch-screensaver", 'force')
  raise 'Duplicate launch was not blocked' unless status.success? && File.empty?(env['CALLS'])
  log.puts 'CHECKPOINT: duplicate launch blocked'

  Open3.popen2e(env, 'bash', "#{root}/bin/cmd-screensaver") do |input, output_stream, thread|
    begin
      Timeout.timeout(5) do
        sleep 0.05 until File.exist?(env['EFFECTS'])
        sleep 1.2
        raise 'Concurrent effects spawned' unless File.readlines(env['EFFECTS']).size == 1
        input.write('x')
        input.flush
        raise 'Input did not close screensaver' unless thread.value.success?
      end
      log.puts output_stream.read.inspect
    ensure
      Process.kill('TERM', thread.pid) if thread.alive?
    end
  end
  pid = Integer(File.read(env['EFFECTS']).strip)
  begin
    Process.kill(0, pid)
    raise 'Effect process leaked after exit'
  rescue Errno::ESRCH
    log.puts 'CHECKPOINT: one effect at a time; keyboard input closes it without leaking processes'
  end
  raise 'Cursor not restored' unless File.read(env['CALLS']).include?('invisible = false')
  log.puts 'PASS: screensaver regression test; exit code 0'
rescue StandardError => e
  log.puts "FAIL: #{e.message}; exit code 1"
  warn File.read(log.path) if log.flush
  exit 1
ensure
  log.close
end
puts File.read(log.path)
