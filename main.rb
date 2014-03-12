# encoding: UTF-8
require 'readline'
require 'yaml'
require 'fileutils'

system 'cls'
puts 'Loading Smart Ruby Console'
puts '__________________________'

#write extension to file/ return - extension array
def set_settings(settings)
  File.open("C:\\Program Files\\srbc\\settings.yml", 'w') do |file|
    file.write settings.to_yaml
  end
  YAML::load_file "C:\\Program Files\\srbc\\settings.yml"
end

#try read settings, if not exsist crate settings file
begin
  ext = YAML::load_file "C:\\Program Files\\srbc\\settings.yml"
rescue
  unless File.directory? "C:\\Program Files\\srbc\\"
    FileUtils.makedirs "C:\\Program Files\\srbc\\"
  end
  ext = set_settings ['*.rb']
end

puts "\n print @help for help\n\n"

#it's trap for blick ctrl+c
trap('INT') {puts "\nprint @exit"}

x=true
while x do
  #get current path
  path = Dir.pwd

  #whaite
    command = Readline.readline("#{path}~ ", true)
    command = nil if command.nil?
    if command =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == command
      Readline::HISTORY.pop
    end

  cmd = command.gsub "#{path}~ ", ''

  #если команда перехода, то
  if cmd =~ /cd/

    #если переход на уровень вверх
    if cmd =~ /\.\./ || cmd =~/^cd$/
      temp_path = path.split '/'
      temp_path.delete_at temp_path.length-1
      path = temp_path.join "\\"
      Dir.chdir path

    #иначе переход по полному пути
    else
      begin
        Dir.chdir cmd.gsub 'cd ', ''
      rescue
        puts 'Wrong path'
      end
    end

  #  если переход на другой том
  elsif cmd =~ /\w:|\$/
    Dir.chdir cmd.gsub 'cd ', ''

  #  команда выхода из приложения
  elsif cmd == '@exit'
    x = false
    puts 'Exiting Smart Ruby Console'

  elsif cmd == '@help'
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


  elsif cmd == '@list'
    puts ext

  elsif cmd =~ /@add/
    new_ext = cmd.gsub "@add ", ""
    if new_ext =~ /^\*\.\w*$/
      ext << new_ext
    else
      puts 'Wrong format! You muts type "@add *.extenssion"'
    end

    set_settings ext



  #  пользователь хочет выполнить файл или команду
  else
    file_list =[]
    #получаем список файлов по расширениям в папке
    ext.each do |extension|
        file = Dir.glob extension

        #если имя файла не сопадает с запрошенным - удаляем его
        file.delete_if {|f| f !~ /#{cmd}/}
        file_list = file_list.concat file
    end

    #если один файл
    if file_list.length == 1
      system "ruby #{file_list[0]}"
    #  не найдено фалов - значит команда
    elsif file_list.length == 0
      p "run command #{cmd}"
      system cmd
    # в остальных случаях файлов > 1
    else
      puts 'We find, more than one file:'
      # TODO добавить выбор номера файла если их несколько в формате @1 - первый файл
      i = 0
      file_list.each do |file|
        i += 1
        puts " #{i} | #{file}"
      end
    end

  end

end