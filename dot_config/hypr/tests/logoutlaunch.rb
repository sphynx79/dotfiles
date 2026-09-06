require 'fileutils'
require 'json'
require 'open3'
require 'tmpdir'

root = File.expand_path('..', __dir__)
scratch_root = File.join(Dir.home, '.pi/agent/tmp')
FileUtils.mkdir_p(scratch_root)
scratch = Dir.mktmpdir('logoutlaunch-test.', scratch_root)
puts "START: isolated wlogout test; scratch: #{scratch}"
at_exit { warn "FAIL: wlogout test; scratch: #{scratch}" if $! }
home = "#{scratch}/home"
bin = "#{scratch}/bin"
themes = "#{home}/.config/hypr/themes"
FileUtils.mkdir_p([bin, "#{themes}/current", "#{home}/.config/wlogout"])
%w[layout style.css icons].each do |name|
  File.symlink("#{Dir.home}/.config/wlogout/#{name}", "#{home}/.config/wlogout/#{name}")
end
stub = <<~'BASH'
  #!/usr/bin/env bash
  case "${0##*/}" in
    pgrep) exit "${RUNNING:-1}" ;;
    pkill) printf 'closed\n' >"$CLOSED" ;;
    gsettings) echo 'unexpected gsettings call' >&2; exit 99 ;;
    hyprctl) printf '%s\n' "$MONITORS" ;;
    notify-send) printf '%s\n' "$*" >&2 ;;
    wlogout)
      while (($#)); do
        if [[ "$1" == --css ]]; then cp -- "$2" "$CSS"; fi
        shift
      done
      ;;
  esac
BASH
%w[pgrep pkill gsettings hyprctl notify-send wlogout].each do |command|
  File.write("#{bin}/#{command}", stub)
  File.chmod(0o755, "#{bin}/#{command}")
end
env = { 'HOME' => home, 'PATH' => "#{bin}:#{ENV.fetch('PATH')}", 'CLOSED' => "#{scratch}/closed" }
%w[my-theme catppuccin catppuccin-latte everforest].each do |theme|
  link = "#{themes}/current/theme"
  File.unlink(link) if File.symlink?(link)
  File.symlink("#{root}/themes/#{theme}", link)
  [1, 1.25, 1.5, 2].each do |scale|
    css_path = "#{scratch}/#{theme}-#{scale}.css"
    monitors = [{ focused: false, width: 1920, height: 1080, scale: 1 },
                { focused: true, width: 5120, height: 1440, scale: scale }]
    output, status = Open3.capture2e(env.merge('MONITORS' => monitors.to_json, 'CSS' => css_path),
                                    'bash', "#{root}/bin/logoutlaunch")
    raise "Launch failed: #{output}" unless status.success? && output.empty?
    css = File.read(css_path)
    color = theme == 'catppuccin-latte' ? 'black' : 'white'
    raise "Wrong icons for #{theme}" unless css.include?("/lock_#{color}.png")
    raise 'Unexpanded template variable' if css.include?('${') || css.include?('$HOME')
    width, height = [(5120 / scale).floor, (1440 / scale).floor]
    raise "Wrong margins at scale #{scale}" unless css.include?("margin : #{height * 25 / 100}px 0px 0px #{width * 35 / 100}px;")
    raise "Wrong hover margins at scale #{scale}" unless css.include?("margin : #{height * 20 / 100}px 0px 0px #{width * 32 / 100}px;")
    raise "Wrong font at scale #{scale}" unless css.include?("font-size: #{height * 2 / 100}px;")
    css.scan(/url\("([^"]+)"\)/).flatten.each { |path| raise "Missing icon: #{path}" unless File.file?(path) }
    puts "PASS: #{theme}, scale #{scale}: icons, logical dimensions, resources"
  end
  colors = File.read("#{root}/themes/#{theme}/wlogout.css").scan(/@define-color ([\w-]+) (#\h{6});/).to_h
  luminance = lambda do |hex|
    channels = hex.delete_prefix('#').scan(/../).map { |v| v.to_i(16) / 255.0 }
    linear = channels.map { |v| v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055)**2.4 }
    linear.zip([0.2126, 0.7152, 0.0722]).sum { |v, weight| v * weight }
  end
  %w[main-bg wb-act-bg wb-hvr-bg].each do |background|
    text, bg = [colors.fetch('btn-fg'), colors.fetch(background)].map(&luminance).sort
    ratio = (bg + 0.05) / (text + 0.05)
    raise "Low contrast #{theme}/#{background}: #{ratio}" unless ratio >= 4.5
  end
  puts "PASS: #{theme}: text contrast >= 4.5 in normal, focus and hover states"
end
output, status = Open3.capture2e(env.merge('RUNNING' => '0'), 'bash', "#{root}/bin/logoutlaunch")
raise "Toggle failed: #{output}" unless status.success? && File.read("#{scratch}/closed") == "closed\n"
output, status = Open3.capture2e(env.merge('MONITORS' => '[]'), 'bash', "#{root}/bin/logoutlaunch")
raise 'Missing monitor was not rejected' if status.success?
puts "PASS: close toggle and missing monitor; no real wlogout or session actions executed"
