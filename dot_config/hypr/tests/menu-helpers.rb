# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'open3'
require 'rbconfig'
require 'tmpdir'

root = File.expand_path('../bin', __dir__)
scratch_root = File.join(Dir.home, '.pi/agent/tmp')
FileUtils.mkdir_p(scratch_root)
scratch = Dir.mktmpdir('menu-helpers-', scratch_root)
bin = File.join(scratch, 'bin')
FileUtils.mkdir_p(bin)
log = File.open(File.join(scratch, 'test.log'), 'w')
report = lambda do |message|
  puts message
  log.puts(message)
  log.flush
end
report.call("START: menu helper regression tests; scratch: #{scratch}")

stub = File.join(bin, 'stub')
File.write(stub, <<~RUBY)
  #!#{RbConfig.ruby}
  require 'json'
  name = File.basename($PROGRAM_NAME)
  File.open(ENV.fetch('CALL_LOG'), 'a') { |file| file.puts([name, *ARGV].to_json) }
  case name
  when 'pacman', 'yay'
    if %w[-Slq -Slqa -Qqe].include?(ARGV.first)
      warn 'mock: package database unavailable' unless ENV.fetch('LIST_STATUS') == '0'
      puts "package-a\\npackage-b"
      exit ENV.fetch('LIST_STATUS').to_i
    end
    warn 'mock: package operation failed' unless ENV.fetch('COMMAND_STATUS') == '0'
    exit ENV.fetch('COMMAND_STATUS').to_i
  when 'fzf'
    STDIN.read
    puts "package-a\\npackage-b" if ENV.fetch('SELECT_STATUS') == '0' && ENV['EMPTY_SELECTION'] != '1'
    exit ENV.fetch('SELECT_STATUS').to_i
  when 'sudo', 'setsid'
    exec(*ARGV)
  when 'app2unit.sh'
    exec(*(ARGV.first == '-t' ? ARGV.drop(2) : ARGV))
  when 'systemd-run'
    exec(*ARGV.drop(ARGV.index('bash')))
  when 'elephant'
    exit 0 unless ARGV.first == 'query'
    count = File.readlines(ENV.fetch('CALL_LOG')).count { |line| JSON.parse(line).first == 'elephant' }
    delay = ENV.fetch('ELEPHANT_READY_AFTER').to_i
    exit(delay.negative? || count <= delay ? 1 : 0)
  when 'xdg-terminal-exec'
    exec(*ARGV.drop(ARGV.index('-e') + 1))
  when 'menu-test-command'
    exit ENV.fetch('COMMAND_STATUS').to_i
  end
RUBY
File.chmod(0o755, stub)
%w[pacman yay sudo fzf updatedb show-done show-logo setsid app2unit.sh xdg-terminal-exec
   menu-test-command systemctl pkill elephant sleep walker systemd-run].each do |name|
  File.symlink(stub, File.join(bin, name))
end

env = {
  'PATH' => "#{bin}:#{File.dirname(RbConfig.ruby)}:/usr/bin",
  'CALL_LOG' => File.join(scratch, 'calls.jsonl'),
  'LIST_STATUS' => '0', 'SELECT_STATUS' => '0', 'COMMAND_STATUS' => '0',
  'EMPTY_SELECTION' => '0', 'ELEPHANT_READY_AFTER' => '0'
}
run = lambda do |name, overrides = {}, args = []|
  File.write(env.fetch('CALL_LOG'), '')
  output, status = Open3.capture2e(env.merge(overrides), '/usr/bin/bash', File.join(root, name), *args)
  log.puts(output)
  calls = File.readlines(env.fetch('CALL_LOG')).map { |line| JSON.parse(line) }
  [status.exitstatus, calls, output]
end
check = lambda do |condition, message|
  raise message unless condition

  report.call("PASS: #{message}")
end
transaction = ->(calls) { calls.find { |name, *args| %w[pacman yay].include?(name) && %w[-S -Rns].include?(args.first) } }

%w[pkg-install pkg-aur-install pkg-remove].each do |name|
  report.call("CHECKPOINT: #{name}")
  status, calls = run.call(name)
  check.call(status.zero? && transaction.call(calls)&.last(3) == ['--', 'package-a', 'package-b'],
             "#{name}: one transaction preserves the two selected arguments")
  check.call(calls.any? { |call| call.first == 'show-done' }, "#{name}: success is acknowledged")
  if name == 'pkg-remove'
    check.call(!transaction.call(calls).include?('--noconfirm'), "#{name}: pacman confirmation remains enabled")
  end

  [1, 130].each do |cancel|
    status, calls = run.call(name, 'SELECT_STATUS' => cancel.to_s)
    check.call(status.zero? && !transaction.call(calls), "#{name}: cancellation #{cancel} changes nothing")
  end
  status, calls = run.call(name, 'EMPTY_SELECTION' => '1')
  check.call(status.zero? && !transaction.call(calls), "#{name}: empty selection changes nothing")

  status, calls = run.call(name, 'LIST_STATUS' => '7')
  check.call(status == 7 && calls.none? { |call| call.first == 'fzf' }, "#{name}: database failure is propagated")
  status, calls = run.call(name, 'SELECT_STATUS' => '2')
  check.call(status == 2 && !transaction.call(calls), "#{name}: picker failure is propagated")
  status, calls, output = run.call(name, 'COMMAND_STATUS' => '7')
  check.call(status == 7 && calls.none? { |call| %w[show-done updatedb].include?(call.first) } &&
             output.include?('failed'), "#{name}: operation failure is not presented as success")
  status, = run.call(name, 'PATH' => '/nonexistent')
  check.call(status == 127, "#{name}: missing prerequisite is rejected")
end

[0, 7].each do |expected|
  status, calls, output = run.call('launch-floating-terminal-with-presentation',
                                 { 'COMMAND_STATUS' => expected.to_s }, ['menu-test-command'])
  check.call(status == expected, "presentation: command exit #{expected} is preserved")
  check.call(calls.any? { |call| call.first == 'show-done' } == expected.zero?,
             "presentation: success message only for exit zero (#{expected})")
  check.call(output.include?('failed'), 'presentation: failure is visible') unless expected.zero?
end
report.call('CHECKPOINT: restart readiness uses IPC, not the installed provider list')
status, calls = run.call('restart-walker', 'ELEPHANT_READY_AFTER' => '-1')
check.call(status == 1 && calls.none? { |call| call.first == 'walker' },
           'restart: unavailable Elephant fails without launching Walker')
status, calls = run.call('restart-walker', 'ELEPHANT_READY_AFTER' => '2')
queries = calls.select { |call| call.first == 'elephant' }
check.call(status.zero? && queries.size == 3 && queries.all? { |call| call[1] == 'query' },
           'restart: waits for a successful read-only query before launching Walker')
report.call('PASS: all menu helper checks; no real package, terminal or privileged operation executed')
