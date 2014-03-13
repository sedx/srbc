# encoding: UTF-8
require 'readline'
require 'yaml'
require 'fileutils'
require_relative './lib/srbc'


system 'cls'
puts 'Loading Smart Ruby Console'
puts '__________________________'

srbc = SRBC.new
srbc.read_settings

puts "\n print @help for help\n\n"

#it's trap for blick ctrl+c
trap('INT') {puts "\nprint @exit"}

$x=true

while $x do
  #get current path
  path = Dir.pwd.gsub "/", "\\"

  #wait command and realise history of command
    command = Readline.readline("#{path}~ ", true)
    command = nil if command.nil?
    if command =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == command
      Readline::HISTORY.pop
    end

  cmd = command.gsub "#{path}~ ", ''


  #if user type command start with @ - run srbc command
  if cmd =~ /^@/
    srbc.srbc_command cmd.gsub "@", ""
  else

  case cmd

    #if user want change folder, SRBC change current work dir
    when  /cd/

      if cmd =~ /\.\./ || cmd =~/^cd$/
        temp_path = path.split '/'
        temp_path.delete_at temp_path.length-1
        path = temp_path.join "\\"
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

      file_list = srbc.get_file_list cmd

      #run file if find only one
      if file_list.length == 1
        file_list.each do |name, args|
        srbc.run_file name, args
      end

      #  не найдено фалов - значит команда
      elsif file_list.length == 0
        p "run command #{cmd}"
        srbc.run_programm cmd

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
            srbc.run_file numbered_files[num_file], file_list[numbered_files[num_file]]
          end
        end
      end

    end
  end

end