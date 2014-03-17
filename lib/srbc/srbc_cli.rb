module SRBC_cli
#  contain commandline inetfeice
#  and detect SRBC command execute, file or system programm

  def run()

    if @settings[@executor].nil?
      puts "\n Executor not defined. Run srbc with -add:<executor> options "
      self.runed = false
    else
      @ext = @settings[@executor]
    end

    while self.lunched do
      #get current path
      path = Dir.pwd

      #wait command and realise history of command
      command = Readline.readline("#{@executor.chr.upcase}# #{path.gsub "/", "\\"}~ ", true)
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

          # command cd - SRBC change current work dir
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

          #  command X: change current work dir if user whant change volume
          when /^\w:$/
            Dir.chdir cmd.gsub 'cd ', ''


          #run with skip executor.
          # Use when you whant execute system command ping and have ping.rb un current folder
          when /^\!/
            run_program cmd.gsub '!',''

          # run app or other program
          else

            file_list = self.get_file_list cmd

            #run file if find only one
            if file_list.length == 1
              file_list.each do |name, args|
                run_file name, args
              end

              #  не найдено фалов - значит команда
            elsif file_list.length == 0
              p "run command #{cmd}"
              run_program cmd

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
                  run_file numbered_files[num_file], file_list[numbered_files[num_file]]
                end
              end
            end
        end
      end
    end
  end
end