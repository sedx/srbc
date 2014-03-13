#require "srbc/version"

class SRBC

    #write extension to file/ return - extension array
    def set_settings(settings)

      #сheck added extension early or not
      unless @ext.include? settings
        @ext << settings
        File.open("C:\\Program Files\\srbc\\settings.yml", 'w') do |file|
          file.write @ext.to_yaml
        end
      else
        puts 'Extension already added'
      end
    end


  #try read settings, if not exsist crate settings file
    def read_settings
      begin
        @ext =  YAML::load_file "C:\\Program Files\\srbc\\settings.yml"
      rescue
        unless File.directory? "C:\\Program Files\\srbc\\"
          FileUtils.makedirs "C:\\Program Files\\srbc\\"
        end
         set_settings ['*.rb']
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
          puts @ext

        when /add/
          new_ext = command.gsub 'add ', ''
          if new_ext =~ /^\*\..*$/ && new_ext !~ /^\*\.$/
            set_settings new_ext
          else
            puts 'Wrong format! You muts type "@add *.extenssion"'
          end


        else
          puts "Unknow SRBC command. Use @help for help"
      end

    end

    def get_file_list (name)
      file_name = name.split(" ")[0]
      args = name.split(" ")[1..name.split(" ").length-1].join" "
      file_list ={}

      #get file list each extension specified in settings.yml
      @ext.each do |extension|
        file = Dir.glob extension

        #delete files not compare with typed file name
        file.delete_if {|f| f !~ /#{file_name}/}
        file.each do |file_nme|
          file_list = file_list.merge Hash[file_nme, args]
        end
        end

      return file_list
    end

  def run_programm(name)
    system "#{name}"
  end

  def run_file(name, args="")
    #todo: run file with arguments. spit to array by " "
     #puts "RUNN: ruby #{name} #{args}"
     system "ruby #{name} #{args}"
    end
  end

