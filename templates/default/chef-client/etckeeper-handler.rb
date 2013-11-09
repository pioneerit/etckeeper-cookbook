require 'rubygems'
require 'chef/log'
require 'chef'

module Etckeeper
  class Report < Chef::Handler
    def report

      Chef::Log.info "Etckeeper::Report handler started"
     
      # only commit when status is success ???
      message = [
        "chef-client status",
        "#{host_name} #{prefix}.success #{run_status.success? ? 1 : 0}",
        "#{host_name} #{prefix}.updated_resources_num #{run_status.updated_resources.length}",
      ].join(" ")

      #File.open(tempfile, 'w') {|f| f.write(message)}
      Chef::Log.debug "git persist change to etc/" 
      #Chef::Log.debug `#{node.zabbix.install_dir}/bin/zabbix_sender --config #{node.zabbix.etc_dir}/zabbix_agentd.conf --input-file #{tempfile}`
    end
  end
end
