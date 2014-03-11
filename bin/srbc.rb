#!/usr/bin/env ruby
# encoding: UTF-8
puts "Loading Smart Ruby Console"
ext = ['*.rb', '*.md']

x=true
while x do
  path = Dir.pwd
  print "#{path.gsub "/", "\\"}>"
  command = gets.chomp
  cmd = command.gsub "#{path}>", ""
  if cmd =~ /cd/
    if cmd =~ /\.\./ || cmd =~/^cd$/
      temp_path = path.split "/"
      temp_path.delete_at temp_path.length-1
      path = temp_path.join "\\"
      Dir.chdir path
    else Dir.chdir cmd.gsub "cd ", "" end
  elsif cmd =~ /:\\/
    Dir.chdir cmd.gsub "cd ", ""
  elsif cmd == "exit"
    x = false
    puts 'Exiting Smart Ruby Console'
  else
    file_list =[]
    ext.each do |extension|
        file = Dir.glob extension
        file.delete_if {|f| f !~ /#{cmd}/}
        file_list = file_list.concat file
    end


    if file_list.length == 1
      system "ruby #{file_list[0]}"
    elsif
      file_list.length == 0
      p "run command #{cmd}"
      system cmd
    else
      puts "We find, more than one file:"
      file_list.each do |file|
        puts "#{file}"
      end
    end

  end

end