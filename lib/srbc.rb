#require "srbc/version"

module Srbc

    #write extension to file/ return - extension array
    def set_settings(settings)
      File.open("C:\\Program Files\\srbc\\settings.yml", 'w') do |file|
        file.write settings.to_yaml
      end
      YAML::load_file "C:\\Program Files\\srbc\\settings.yml"
    end


  #try read settings, if not exsist crate settings file
    def read_settings
      begin
        return YAML::load_file "C:\\Program Files\\srbc\\settings.yml"
      rescue
        unless File.directory? "C:\\Program Files\\srbc\\"
          FileUtils.makedirs "C:\\Program Files\\srbc\\"
        end
        return set_settings ['*.rb']
      end
    end

    def srbc_command(command)
      case command
        when 'exit'
          $x = false
          puts 'Exiting Smart Ruby Console'

        when 'help'
          puts "\n Smart Ruby Console help"
          puts "=======================\n"

          puts "\n\nUsage:    You can run *.rb files, or other in ruby
            Just print 'main' to execute 'ruby main.rb'
            If in folder same files contains 'main' (for
            example Class_main.rb and main.rb) SRBC ask you what file run

            When SRBC run default MS symbol in console > replace with ~
            "

          puts 'Comands'

          puts '| @help        | this help        |'
          puts '| @list        | extension list   |'
          puts '| @exit        | exit from app    |'
          puts '| @add "*.rb"  | add extension    |'


        when 'list'
          puts $ext

        when /@add/
          new_ext = cmd.gsub '@add ', ''
          if new_ext =~ /^\*\.\w*$/
            ext << new_ext
          else
            puts 'Wrong format! You muts type "@add *.extenssion"'
          end
          set_settings ext

        else
          puts "Unknow SRBC command. Use @help for help"
      end

    end

    def get_file_list (name)
      file_list =[]

      #get file list each extension specified in settings.yml
      ext.each do |extension|
        file = Dir.glob extension

        #delete files not compare with typed file name
        file.delete_if {|f| f !~ /#{name}/}
        file_list = file_list.concat file
      end
    end
end
