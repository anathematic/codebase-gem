module Codebase
  class Command < CommandBase

    ## =========================================================================================================
    ## Launchers
    ## =========================================================================================================

    def default
      if directory.repository?
        launch directory.project
      else
        launch
      end
    end
    alias_method :dashboard, :default
    
    def messages
      launch 'messages'
    end
    alias_method :me, :messages
    
    def tickets
      launch directory.project, 'tickets'
    end
    alias_method :ti, :tickets
    
    def new_ticket
      launch directory.project, 'tickets', 'new'
    end
    alias_method :nti, :new_ticket
    
    def milestones
      launch directory.project, 'milestones'
    end
    alias_method :mi, :milestones
    
    def time
      launch directory.project, 'time'
    end
    alias_method :tm, :time
    
    def wiki
      launch directory.project, 'wiki'
    end
    alias_method :wi, :wiki
    
    def errors
      launch directory.project, 'errors'
    end
    alias_method :er, :errors
    
    def browser
      launch directory.project, directory.repository, 'tree', directory.working_branch
    end
    alias_method :br, :browser
    
    def commits
      launch directory.project, directory.repository, 'commits', directory.working_branch
    end
    alias_method :co, :commits
    
    def deployments
      launch directory.project, directory.repository, 'deployments'
    end
    alias_method :de, :deployments
    
    def tasks
      launch directory.project, directory.repository, 'tasks'
    end
    alias_method :ta, :tasks
    
    ## =========================================================================================================
    ## Remote Branch Management
    ## =========================================================================================================
    
    def mkbranch(branch_name, source_branch = 'master')
      commands = []
      commands << "git push origin #{source_branch}:refs/heads/#{branch_name}"
      commands << "git fetch origin"
      commands << "git branch --track #{branch_name} origin/#{branch_name}"
      commands << "git checkout #{branch_name}"
      execute_commands(commands)
    end
    
    def rmbranch(branch_name)
      commands = []
      commands << "git push origin :#{branch_name}"
      commands << "git branch -d #{branch_name}"
      execute_commands(commands)
    end
    
    ## =========================================================================================================
    ## Commit Logger
    ## =========================================================================================================

    def log(message)
      current = directory.send(:git, :config, 'codebase.log').split("\\n")
      current << message
      directory.send(:git, :config, 'codebase.log', "\"#{current.join("\n")}\"")
    end
    
    def showlog
      output = directory.send(:git, :config, 'codebase.log').split("\n").map{|line| " * #{line}\n"}
      if output.empty?
        $stderr.puts "There is nothing in the Codebase Log at the moment. Add something using 'cb log \"My Message Here\"'"
        Process.exit(1)
      else
        puts output
      end
    end
    
    def clearlog
      directory.send(:git, :config, '--unset', 'codebase.log')
      puts "Codebase log cleared."
    end
    
    def commit(message = '')
      output = directory.send(:git, :config, 'codebase.log').split("\n").map{|line| " * #{line}\n"}
      if output.empty? || message.nil? || message == ''
        $stderr.puts "You haven't added a message and/or added log entries. You may want to use a normal commit using 'git commit -m ...'"
        Process.exit(1)
      else
        system("git commit -m '#{message}\n\n#{output}'")
        clearlog
      end
    end
    
  end
end
