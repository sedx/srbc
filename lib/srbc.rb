require 'srbc/srbc_command'
require 'srbc/srbc_cli'


class SRBC
    attr_accessor :settings, :lunched
    include SrbcCommand
    include SRBC_cli


    def initialize(executor)
      @ext = []
      @gem_root = Gem.loaded_specs['srbc'].full_gem_path
      @executor = executor
      @settings ={}
      @lunched = true
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
        @settings =  YAML::load_file "#{@gem_root}/settings.yml"
    end

    def get_file_list (name)
      file_name = name.split(" ")[0]
      args = name.split(" ")[1..name.split(" ").length-1].join" "
      file_list ={}

      #get file list each extension specified in settings.yml
      @ext.each do |extension|
        file = Dir.glob extension

        #delete files not compare with typed file name
        file.delete_if {|f| f !~ /^#{file_name}/}
        file.each do |file_nme|
          file_list = file_list.merge Hash[file_nme, args]
        end
        end

      file_list
    end

end

