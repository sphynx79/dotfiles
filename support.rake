require 'byebug'
class << File
   alias_method :old_symlink, :symlink
   alias_method :old_symlink?, :symlink?

   def symlink(source, dest, out = nil)
      if check_os == "WINDOWS"
         dest = File.expand_path(dest).gsub(?/, ?\\)
         source = File.expand_path(source).gsub(?/, ?\\)
         opt = File.directory?(source) ? '/d ' : ''
         output = `cmd.exe /c mklink #{opt}"#{dest}" "#{source}"` # & pause`)
         out.puts output if out
      else
         self.old_symlink(source, dest)
      end
   end

   def symlink?(file_name)
      #if on windows, call mklink, else self.symlink
      if check_os == "WINDOWS"
         #vulnerable to command injection because calling with cmd.exe with /c?
         file_name    = File.expand_path(file_name).gsub(?/, ?\\) 
         find_command =  (`cmd.exe /c where findstr.exe`).split("\n").grep(/Windows/).first
         if  File.file? file_name
            output = `cmd.exe /c dir /al "#{file_name}" |  "#{find_command}" "SYMLINK"` # & pause
         else
            file_name = file_name.sub((File.basename(file_name)),"")
            output = `cmd.exe /c dir /al "#{file_name}" |  "#{find_command}" "SYMLINKD"` # & pause
         end
         return output == "" ? false : true
      else
         self.old_symlink?(file_name)
      end
   end
end


def check_os
   case RUBY_PLATFORM.downcase
   when ->(n) { n =~ /darwin/}                        then os = "MAC"
   when ->(n) { n =~ /mswin32|cygwin|mingw|bccwin/i}  then os = "WINDOWS"
   when ->(n) { n =~ /linux/}                         then os = "LINUX"
   else os = "OTHER"
   end
end

