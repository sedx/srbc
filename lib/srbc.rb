require "srbc/version"


class SRBC

    def initialize
      @ext = []
      @gem_root = Gem.loaded_specs['srbc'].full_gem_path


    end
    #write extension to file/ return - extension array
    def set_settings(settings)

      #сheck added extension early or not
      unless @ext.include? settings
        @ext << settings
        File.open("#{@gem_root}/settings.yml", 'w') do |file|
          file.write @ext.to_yaml
        end
      else
        puts 'Extension already added'
      end
    end


  #try read settings, if not exsist crate settings file
    def read_settings
      begin
        @ext =  YAML::load_file "#{@gem_root}/settings.yml"
      rescue
        set_settings '*.rb'
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
            Just print 'srbc' to execute 'ruby srbc.rb'
            If in folder same files contains 'srbc' (for
            example Class_main.rb and srbc.rb) SRBC ask you what file run

            When SRBC run default MS symbol in console > replace with ~
            "

          puts 'Comands'

          puts '| @help        | this help        |'
          puts '| @list        | extension list   |'
          puts '| @exit        | exit from app    |'
          puts '| @add "*.rb"  | add extension    |'
          puts "\n\n"


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
     #puts "RUNN: ruby #{name} #{args}"
     system "ruby #{name} #{args}"
  end

  def run
    while $x do
      #get current path
      path = Dir.pwd

      #wait command and realise history of command
      command = Readline.readline("#{path.gsub "/", "\\"}~ ", true)
      command = nil if command.nil?
      if command =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == command
        Readline::HISTORY.pop
      end

      cmd = command.gsub "#{path}~ ", ''


      #if user type command start with @ - run srbc command
      if cmd =~ /^@/
        self.srbc_command cmd.gsub "@", ""
      else

        case cmd

          #if user want change folder, SRBC change current work dir
          when  /cd/

            if cmd =~ /\.\./ || cmd =~/^cd$/
              temp_path = path.split '/'
              temp_path.delete_at temp_path.length-1
              p temp_path
              path = temp_path.join "\\"
              p path
              Dir.chdir path

            else
              begin
                Dir.chdir cmd.gsub 'cd ', ''
              rescue
                puts 'Wrong path'
              end
            end

          #  run this change current work dir if user whant change volume
          when /^\w:$/
            Dir.chdir cmd.gsub 'cd ', ''


          # run app or other program
          else

            file_list = self.get_file_list cmd

            #run file if find only one
            if file_list.length == 1
              file_list.each do |name, args|
                self.run_file name, args
              end

              #  не найдено фалов - значит команда
            elsif file_list.length == 0
              p "run command #{cmd}"
              self.run_programm cmd

              # в остальных случаях файлов > 1
            else

              puts 'We find, more than one file:'

              i = 0
              numbered_files = {}
              puts " 0 | Cancel "
              file_list.each do |file|
                i += 1
                puts " #{i} | #{file[0]}"
                numbered_files[i] = file[0]
              end
              num_file = -1
              while num_file < 0
                puts "Choose file to run (type @ and number of file)"
                num_file = gets.chomp.gsub("@", "").to_i
                if num_file > 0
                  self.run_file numbered_files[num_file], file_list[numbered_files[num_file]]
                end
              end
            end

        end
      end
  end

  end
end

