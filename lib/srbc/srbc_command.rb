require_relative 'version'
module SrbcCommand


  #method to execute command sterst with @
  def srbc_command(command)

    case command.downcase
      when 'e','exit'
        self.lunched = false
        puts 'Exiting Smart Ruby Console'

      when 'h','help'
        puts "Smart Ruby Console help SRBC #{SrbcVersion::VERSION}"
        File.open("#{@gem_root}/help", 'r') do |helpfile|
          while line=helpfile.gets
            puts line
          end
        end

      #hot change executor
      when /^#/
      @executor = command.gsub(' ','').gsub '#', ''
        @ext = @settings[@executor]
        if @ext.nil?
          puts "You use #{@executor} first time. Please add extension!"
          ext = gets.chomp
          set_settings @executor, ext
        end

      when 'l','list'
        puts "Current [#{@executor}]:"
        puts @ext
        @settings.each do |executor, extensions|
          unless executor == @executor
            puts "\n"
            puts "[#{executor}]"
            puts extensions
          end
        end

      when /^add/
        new_ext = command.gsub 'add ', ''

        set_settings @executor, new_ext
      when 'c','current'
        puts "\nCurrent executor: #{@executor}"

      when /^delete/
        executor_to_delete = command.gsub 'delete ', ''
        if @settings[executor_to_delete].nil?
          puts "Can't find #{executor_to_delete}"
        else
        if @executor == executor_to_delete
          @executor = 'ruby'
        end
        @settings.delete (executor_to_delete)
        save_settings
        puts "#{executor_to_delete} deleted"
        end

      else
        puts "Unknow SRBC command. Use @help for help"
    end

  end

  def run_program(name)
    system "#{name}"
    if $?.pid == 0
      puts "#{name} not found"
    end
  end

  def run_file(name, args="")
    #puts "RUNN: ruby #{name} #{args}"
    system "#{@executor} #{name} #{args}"
  end
end