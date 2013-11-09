require 'rubygems'
require 'chef/log'
#require 'tempfile'

module Etckeeper
  class ClientHandler < Chef::Handler
    def report

      Chef::Log.info "Etckeeper::Report handler started"
     
      # only commit when status is success ???
      message = [
        "chef-client",
        "#{run_status.success? ? 'success' : 'failed'}",
      ].join(" ")
      
      #tempfile = Tempfile.new('msg')
      #tempfile.write(message)
      #tempfile.close

      Chef::Log.info "persist change to etc/ with git" 
      #Chef::Log.debug `cd /etc; git add -A; git commit -F "#{tempfile.path}"`
      Chef::Log.debug `etckeeper commit "#{message}"`

    end
  end
end
