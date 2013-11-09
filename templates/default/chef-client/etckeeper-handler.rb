require 'rubygems'
require 'chef/log'
require 'tempfile'

module Etckeeper
  class ClientHandler < Chef::Handler
    def report

      Chef::Log.info "Etckeeper::Report handler started"
     
      # only commit when status is success ???
      message = [
        "chef-client",
        "status:#{run_status.success? ? 1 : 0}",
        "numupdates:#{run_status.updated_resources.length}",
      ].join(" ")
      
      tempfile = Tempfile.new('msg')
      tempfile.write(message)
      tempfile.close

      Chef::Log.info "persist change to etc/ with git" 
      Chef::Log.info  `cd /etc; git add -A; git commit -F "#{tempfile.path}"`

    end
  end
end
