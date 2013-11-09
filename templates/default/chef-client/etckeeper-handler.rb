require 'rubygems'
require 'chef/log'
#require 'chef'

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

      #File.open(tempfile, 'w') {|f| f.write(message)}
      Chef::Log.info "git persist change to etc/ #{message}" 
      #Chef::Log.debug `#{node.zabbix.install_dir}/bin/zabbix_sender --config #{node.zabbix.etc_dir}/zabbix_agentd.conf --input-file #{tempfile}`
    end
  end
end
