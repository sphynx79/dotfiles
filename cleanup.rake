namespace :setup do
   desc "cleanup all local symbol link file"
   task :cleanup => :init do
      puts "> cleanup task: Tasks to remove all symbol link"
      puts "    - Clean up the local link"

      Dir['*'].each do |file|
         source   = File.join(Dir.pwd, file)
         basename = File.basename(source)
         next if DO_NOT_SYMLINK.include?(basename)
         target = File.expand_path("#{@home}/.#{basename}")
         if @os == "WINDOWS" && basename == "vim"
            target =  target.sub(".vim","vimfiles")
         end


         if  File.exists? target
            if File.symlink?(target) 
               puts "    - Remove link : #{target}"
               begin
                  rm target, verbose: false
               rescue
                  rmdir target, verbose: false
               end
            end
         end
      end
   end
end

