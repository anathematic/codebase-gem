$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'colored'
require 'codebase_helpers/command_base'
require 'codebase_helpers/command'
require 'codebase_helpers/directory'

module Codebase
  
  class Error < RuntimeError; end
  
  extend self
    
  def run(args)
    begin
      repository = Directory.new
      method = args.shift || 'default'
      command = Codebase::Command.new(repository, args)
      if command.respond_to?(method)
        command.send(method)
      else
        $stderr.puts "Command Not Found - please check http://help.codebasehq.com for documentation."
      end
    rescue Codebase::Error => e
      $stderr.puts e.message
    end

  end

end
