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
    
  end
end