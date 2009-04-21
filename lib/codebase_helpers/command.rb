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
    
  end
end
