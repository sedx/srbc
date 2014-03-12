# encoding: UTF-8
require 'readline'
require 'yaml'
require 'fileutils'
require_relative './lib/srbc'
include Srbc

system 'cls'
puts 'Loading Smart Ruby Console'
puts '__________________________'

ext = read_settings

puts "\n print @help for help\n\n"

#it's trap for blick ctrl+c
trap('INT') {puts "\nprint @exit"}

$x=true

while $x do
  #get current path
  path = Dir.pwd

  #wait command and realise history of command
    command = Readline.readline("#{path}~ ", true)
    command = nil if command.nil?
    if command =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == command
      Readline::HISTORY.pop
    end

  cmd = command.gsub "#{path}~ ", ''


  #if user type command start with @ - run srbc command
  if cmd =~ /^@/
    srbc_command cmd.gsub "@", ""
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

      file_list = get_file_list cmd

      #run file if find only one
      if file_list.length == 1
        system "ruby #{file_list[0]}"
      #  не найдено фалов - значит команда
      elsif file_list.length == 0
        p "run command #{cmd}"
        system cmd
      # в остальных случаях файлов > 1
      else
        puts 'We find, more than one file:'

        i = 0
        file_list.each do |file|
          i += 1
          puts " #{i} | #{file}"
        end
        num_file = -1
        while num_file.to_i < 0
          puts "Choose file to run (type @ and number of file)"
          num_file = gets.chomp.gsub "@", ""
          system "ruby #{file_list[num_file.to_i]}"
        end
        #todo: run file with arguments. spit to array by " "
      end

    end
  end

end