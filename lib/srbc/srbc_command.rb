module SrbcCommand

  #method to execute command sterst with @
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

      #todo: hot change executor

      when 'l','list'
        puts @ext

        #todo: list all executor with extenstion

      when /^a/
        new_ext = command.gsub 'add ', ''

        set_settings @executor, new_ext
      when 'c','current'
        puts "\nCurrent executor: #{@executor}"
      else
        puts "Unknow SRBC command. Use @help for help"
    end

  end

  def run_program(name)
    system "#{name}"
  end

  def run_file(name, args="")
    #puts "RUNN: ruby #{name} #{args}"
    system "#{@executor} #{name} #{args}"
  end
end