require 'fileutils'
require 'open3'
require 'tmpdir'

puts 'START: regressione del prompt group-alias (IPC e Walker simulati)'
begin
  scratch = File.join(Dir.home, '.pi/agent/tmp')
  FileUtils.mkdir_p(scratch)
  Dir.mktmpdir('group-alias-prompt.', scratch) do |dir|
    File.write("#{dir}/hyprctl", <<~'SH')
      #!/usr/bin/env bash
      case "$*" in
        "-j plugin list") printf '%s\n' "$TEST_PLUGINS" ;;
        "groupalias get") printf '\n' ;;
        "groupalias set "*) printf '%s\n' "${*:3}" > "$TEST_RESULT" ;;
        *) printf 'unknown request\n' ;;
      esac
    SH
    File.write("#{dir}/notify-send", "#!/usr/bin/env bash\nexit 0\n")
    File.write("#{dir}/launch-walker", "#!/usr/bin/env bash\nprintf '%s\\n' \"$TEST_ALIAS\"\n")
    %w[hyprctl notify-send launch-walker].each { |name| File.chmod(0o700, "#{dir}/#{name}") }
    script = File.expand_path('../../../bin/group-alias-prompt', __dir__)
    env = { 'PATH' => "#{dir}:#{ENV.fetch('PATH')}", 'TEST_RESULT' => "#{dir}/result",
            'TEST_PLUGINS' => '[]', 'TEST_ALIAS' => 'Editor 🦊 日本語' }
    output, status = Open3.capture2e(env, 'bash', script)
    raise "Plugin assente non rilevato: #{output}" unless status.exitstatus == 1 && !File.exist?("#{dir}/result")
    puts 'CHECKPOINT: plugin assente rifiutato anche con IPC exit 0'
    env['TEST_PLUGINS'] = '[{"name":"group-alias"}]'
    output, status = Open3.capture2e(env, 'bash', script)
    raise "Alias non inviato: #{output}" unless status.success? && File.read("#{dir}/result").strip == env['TEST_ALIAS']
    puts 'CHECKPOINT: plugin presente, alias Unicode inviato'
    File.delete("#{dir}/result")
    env['TEST_ALIAS'] = ''
    output, status = Open3.capture2e(env, 'bash', script)
    raise "Annullamento non rispettato: #{output}" unless status.success? && !File.exist?("#{dir}/result")
    puts 'CHECKPOINT: input vuoto non modifica alias'
  end
  puts 'PASS: tutti i controlli superati; exit code 0'
rescue StandardError => e
  warn "FAIL: #{e.message}; exit code 1"
  exit 1
end
