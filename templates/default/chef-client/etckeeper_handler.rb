require 'rubygems'
require 'chef/log'
require 'chef/mixin/shell_out'

module Etckeeper
  class CommitHandler < ::Chef::Handler
    def report
      unless Etckeeper::Helpers.unclean?
        Chef::Log.debug(
         'Etckeeper::CommitHandler: /etc was not touched by this chef-run'
       )
        return
      end

      Chef::Log.info(
        'Etckeeper::CommitHandler persisting changes of current chef run ' \
        'for /etc'
      )
      Chef::Log.debug Etckeeper::Helpers.git_diff

      # build the commit message
      message = []
      message << "chef-client on #{node.name}: " + (
        exception ? 'failed' : 'success'
      )
      message << ''
      message << (
        "Formatted Exception:\n" + run_status.formatted_exception + "\n"
      ) if exception
      message << 'Updated resources:'
      run_status.updated_resources.each do |res|
        message << "* #{res}"
      end

      Chef::Log.debug `etckeeper commit "#{message.join("\n")}"`
    end
  end
end
