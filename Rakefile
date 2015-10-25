require 'rake'
require 'erb'


# namespace(:server) do
#    desc('Restart web server')
#    task(:restart) do
#       touch('./tmp/restart.txt')
#    end
# end


# muovere un file
# file 'settings.yml' => 'settings.yaml' do
#  mv 'settings.yaml', 'settings.yml'
#  cp 'settings.yaml', 'settings.yml'
# end




# Crea un albero di rectory
# file 'my_gem' do |t| 
#    mkdir t.name 
# end
#
# file 'my_gem/tests' => ['my_gem'] do |t|
#    mkdir t.name 
# end
#
# file 'my_gem/tests/fixtures' => ['my_gem/tests'] do |t|
#    mkdir t.name
# end

# @pkg_files = Array.new
#
# task :default => :clean
#
# task :clean do
#    puts 'Cleaning...'
# end
#
#
#
#
# desc "Says 'Hello, Rake'"
# task :test do
#    puts "Hello"
# end
#
# desc "Says A"
# task :a do
#    puts "A"
# end
#
# desc "Says B"
# task :b do
#    puts "B"
# end
#
# task :prova => [:a, :b] do
#    puts "Michele"
# end
#
#
# task :filelist do
#   @pkg_files = Rake::FileList.new('*') 
# end
#
#
# task :printlist => 'filelist' do
#   p @pkg_files
# end
#


# task :clean do
#   rm_rf "outputs"
# end
#
#
#
# task :tests, [:arg1, :arg2] do |t, args|
#   puts "First argument: #{ args[:arg1] }"
#   puts "Second argument: #{args[:arg2]}"
# end
#rake tests[1,some_random_string] 
#
#Rake::Task["setup:copy"].invoke #A task invocation
#
#

# Dir.glob('*.rake').each { |r| import r }
#
# namespace :setup do
#   desc "Initiate setup. This task serves as a dependency for other tasks."
#   task :init do
#     print "-Check OS"
#     @os   =  check_os
#     print "-Check HOME"
#     @home = ENV["HOME"]
#
#
#
#     name = STDIN.gets.strip
#     if pwd().split('/').last == "Rake"
#       puts "Copying the files to #{name}/lib/tasks."
#
#       print "Do you want to continue with the setup?(y/n): "
#       option = STDIN.gets.strip
#
#       case_code(option)
#     else
#       puts "We are already on the destination directory"
#     end
#     setup_copy
#   end
#
#   def abort_message
#     abort("Exiting. You can each task individually. See rake -T for more info")
#   end
#
#   def case_code(option)
#     case option
#       when /[^Yy]/
#         abort_message
#     end
#   end
# end
#
#
# def setup_copy
#   Rake::Task["setup:copy"].invoke #A task invocation
# end
#
#
#
#
#
#http://www.sitepoint.com/rake-automate-things/
#https://github.com/henrik/dotfiles/blob/master/Rakefile#L38
Dir.glob('*.rake').each { |r| import r }


DO_NOT_SYMLINK = %w[
  .gitignore
  Rakefile
  cleanup.rake
  support.rake
  Appunti.txt
  .git
]

namespace :setup do

   desc "initialize variable and path"   
   task :init do
      puts "> init: Task to initiate a process"
      @home           = ENV["HOME"]
      @os             = check_os

      # case @os
      # when "WINDOWS" then 
      #    @vimfiles_path = @home+"\\vimfiles\\"
      #    @vimrc_path    = @home+"\\.vimrc"
      #    @gvimrc_path   = @home+"\\.gvimrc"
      # when "MAC"
      #    @vimfiles_path = @home+"\\.vim\\"
      #    @vimrc_path    = ""
      #    @gvimrc_path   = ""
      # enp
      #
      # puts "-- OS        => #{@os}\n"
      # puts "-- HOME      => #{@home}\n"
      # puts "-- VIMCONFIG => #{@vimfiles_path}"


   end


   task :install=> :init do #This one too depends on :init
      Dir["*"].each do |file|
         source   = File.join(Dir.pwd, file)
         basename = File.basename(source)
         next if DO_NOT_SYMLINK.include?(basename)
         target = File.expand_path("#{@home}/.#{basename}")
         if @os == "WINDOWS" && basename == "vim"
            target =  target.sub(".vim","vimfiles")
         end
         puts "    - Make link : #{source} ==> #{target}"
         File.symlink(source, target)

      end
        
   end

   task :all => [ :init, :cleanup, :install ] do #Depends on init, cleanup and git tasks.
      puts "> all task: Done"
   end
end


