module Codebase
  
  ## A directory represents the directory the user is currently within.
  
  class Directory
    
    attr_reader :permalink, :account    
    
    def initialize
      get_properties
    end
    
    def repository?
      working_branch
    end
    
    def working_branch
      @working_branch ||= git(:status).split("\n").first.split(" ").last rescue nil
    end
    
    def domain
      if @account
        "#{@account}.codebasehq.com"
      else
        git(:config, 'codebase.domain')
      end
    end
    
    def project
      raise Codebase::Error, "This is not a valid Codebase repository" unless repository?
      @project
    end
    
    def repository
      raise Codebase::Error, "This is not a valid Codebase repository" unless repository?
      @repository
    end

    private
    
    def codebase_remote_name
      configured = git(:config, 'codebase.remote')
      if configured.empty?
        'origin'
      else
        configured
      end
    end
    
    ## Returns the project an repository names base on the git remote URL
    def get_properties
      return unless repository?
      remote_url = git(:config, "remote.#{codebase_remote_name}.url")
      if m = remote_url.match(/git@gitbase.com:(.*)\/(.*)\/(.*)\.git/)
        @account = m[1]
        @project = m[2]
        @repository = m[3]
      else
        raise Codebase::Error, "This is not a valid Codebase repository - #{remote_url} as '#{codebase_remote_name}'"
      end
    end
    
    def git(cmd, *args)
      `git #{cmd} #{args.join(' ')} 2> /dev/null`.strip.chomp
    end
    
    
  end
end