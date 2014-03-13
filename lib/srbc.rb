require "srbc/version"


class SRBC
    attr_accessor :settings

    def initialize(executor)
      @ext = []
      @gem_root = Gem.loaded_specs['srbc'].full_gem_path
      @executor = executor
      @settings ={}


    end
    #write extension to file/ return - extension array
    def set_settings(executor, extension)
      if extension =~ /^\*\..*$/ && extension !~ /^\*\.$/

      #сheck added extension early or not
      unless @ext.include? extension
        @ext << extension
      else
        puts 'Extension already added'
      end
        @settings[executor] = @ext
        File.open("#{@gem_root}/settings.yml", 'w') do |file|
        file.write @settings.to_yaml
        end
      else
      puts 'Wrong format! You muts type "@add *.extenssion"'
      end
    end


  #try read settings, if not exsist crate settings file
    def read_settings
      begin
        @settings =  YAML::load_file "#{@gem_root}/settings.yml"
      end
    end


    def srbc_command(command)
      case command
        when 'e','exit'
          $x = false
          puts 'Exiting Smart Ruby Console'

        when 'h','help'
          File.open("#{@gem_root}/help", 'r') do |helpfile|
            while line=helpfile.gets
              puts line
            end
          end

        when 'l','list'
          puts @ext

        when /^a/
          new_ext = command.gsub 'add ', ''

          set_settings @executor, new_ext
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

  def run()

    if @settings[@executor].nil?
      puts "\n Executor not defined. Run srbc with -add:<executor> options "
      $x = false
    else
      @ext = @settings[@executor]
    end

    while $x do
      #get current path
      path = Dir.pwd

      #wait command and realise history of command
      command = Readline.readline("#{path.gsub "/", "\\"}~ ", true)
      command = nil if command.nil?
      if command =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == command
        Readline::HISTORY.pop
      end

      cmd = command.gsub("#{path}~ ", '').downcase


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

