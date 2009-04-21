module Codebase
  class CommandBase
        
    attr_reader :directory, :args
    
    def initialize(directory, args)
      @directory, @args = directory, args
    end
    
    private

    def launch(*args)
      begin
        gem 'launchy'
        require 'launchy'
        url = "http://#{directory.domain}/" + args.join('/').gsub(/\?\z/, "")
        Launchy::Browser.new.visit(url)
      rescue Gem::LoadError
        raise Codebase::Error, "Sorry, you need to install launchy to do that - give 'gem install launchy' a go."
      end
    end
    
    def execute_commands(array)
      for command in array
        puts "\e[44;33m" + command + "\e[0m"
        exit_code = 0
        IO.popen(command) do |f|
          output = f.read
          exit_code = Process.waitpid2(f.pid)[1]
        end
        if exit_code != 0
          $stderr.puts "An error occured running: #{command}"
          Process.exit(1)
        end
      end
    end
    
  end
end