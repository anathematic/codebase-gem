Capistrano::Configuration.instance(:must_exist).load do
  
  after "deploy:symlink", :add_deployment_to_codebase

  task :add_deployment_to_codebase do
    
    username = `git config codebase.username`.chomp.strip
    api_key  = `git config codebase.apikey`.chomp.strip
    
    regex = /git\@gitbase\.com:(.*)\/(.*)\/(.*)\.git/
    unless m = repository.match(regex)
      puts "  * \e[31mYour repository URL does not a match a valid Codebase Clone URL\e[0m"
    else
      url = "#{m[1]}.codebasehq.com"
      project = m[2]
      repository = m[3]
    
      puts "  * \e[44;33mAdding Deployment to your Codebase account\e[0m"
      puts "      -  Account......: #{url}"
      puts "      -  Username.....: #{username}"
      puts "      -  API Key......: #{api_key[0,10]}..."
    
      puts "      -  Project......: #{project}"
      puts "      -  Repository...: #{repository}"
          
      environment_to_send = ''
      if self.respond_to?(:environment)  && !self.environment.empty?
        environment_to_send = self.environment.dup
        environment_to_send.gsub!(/\W+/, ' ')
        environment_to_send.strip!
        environment_to_send.downcase!
        environment_to_send.gsub!(/\ +/, '-')
        puts "      -  Environment..: #{environment_to_send}"
      end
    
      servers = roles.values.collect{|r| r.servers}.flatten.collect{|s| s.host}.uniq.join(', ') rescue ''
    
      puts "      -  Servers......: #{servers}"
      puts "      -  Revision.....: #{real_revision}"
      puts "      -  Branch.......: #{branch}"

      xml = []
      xml << "<deployment>"
      xml << "<servers>#{servers}</servers>"
      xml << "<revision>#{real_revision}</revision>"
      xml << "<environment>#{environment_to_send}</environment>"
      xml << "<branch>#{branch}</branch>"
      xml << "</deployment>"
            
      require 'net/http'
      require 'uri'
      
      real_url = "http://#{url}/#{project}/#{repository}/deployments"
      puts "      -  URL..........: #{real_url}"
      
      url = URI.parse(real_url)
      
      req = Net::HTTP::Post.new(url.path)
      req.basic_auth(username, api_key)
      req.add_field('Content-type', 'application/xml')
      req.add_field('Accept', 'application/xml')
      res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req, xml.join) }
      case res
      when Net::HTTPCreated then puts "  * \e[32mAdded deployment to Codebase\e[0m"
      else 
        puts "  * \e[31mSorry, your deployment was not logged in Codebase - please check your config above.\e[0m"
      end
    end
    
  end
end
