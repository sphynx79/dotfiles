require 'fileutils'
require 'open3'
require 'tmpdir'

puts 'START: Apps menu cancellation regression'
scratch = File.join(Dir.home, '.pi/agent/tmp')
FileUtils.mkdir_p(scratch)
Dir.mktmpdir('menu-apps-', scratch) do |directory|
  log = File.join(directory, 'calls')
  %w[walker bwrap launch-menu].each do |command|
    File.write(File.join(directory, command), <<~BASH)
      #!/usr/bin/env bash
      printf '%s\\n' '#{command}' "$@" >> "$CALL_LOG"
      #{command == 'bwrap' ? 'exit "$APP_STATUS"' : 'exit 0'}
    BASH
    File.chmod(0o755, File.join(directory, command))
  end
  [0, 130, 1].each do |status|
    File.write(log, '')
    output, result = Open3.capture2e(
      { 'PATH' => "#{directory}:#{ENV.fetch('PATH')}", 'APP_STATUS' => status.to_s,
        'CALL_LOG' => log, 'XDG_RUNTIME_DIR' => directory },
      'bash', File.expand_path('../bin/launch-menu-apps', __dir__)
    )
    calls = File.readlines(log, chomp: true)
    expected = %w[walker --close bwrap --bind / / --dev-bind /dev /dev --tmpfs] +
               ["#{directory}/walker", '--', 'dbus-run-session', '--', 'walker']
    expected << 'launch-menu' if status == 130
    raise "FAIL: status #{status}: #{calls.inspect}\n#{output}" unless calls == expected
    raise "FAIL: wrong exit status #{result.exitstatus}" unless result.exitstatus == (status == 130 ? 0 : status)
    puts "PASS: application exit #{status}, return to menu #{status == 130}"
  end
end
puts 'PASS: no real UI or applications launched'
