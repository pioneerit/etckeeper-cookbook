require 'rubygems'
require 'chef/log'
require 'chef/mixin/shell_out'

module Etckeeper
  class StartHandler < ::Chef::Handler
    def report
      Chef::Log.info 'Etckeeper::StartHandler inspecting /etc'

      if Etckeeper::Helpers.git_repo?
        if Etckeeper::Helpers.unclean?

          Chef::Log.error(
            'Found changes to /etc: ' + Etckeeper::Helpers.git_diff
          )
          Chef::Application.fatal! '/etc is NOT clean. Stopping chef-run'
        else
          Chef::Log.debug '/etc seems clean, continuing'
        end

      else
        Chef::Log.warn '/etc seems to be not a Git repositry'
      end
    end

    # we are overriding this method in order to be able to fail the chef run
    # (all the handlers are called in a way that all their exceptions are
    # caught)
    def run_report_safely(run_status)
      run_report_unsafe(run_status)
    end
  end

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

  class Helpers
    extend Chef::Mixin::ShellOut

    def self.git_repo?
      File.directory?('/etc/.git')
    end

    def self.unclean?
      so = shell_out('etckeeper unclean')
      so.exitstatus == 0
    end

    def self.git_diff
      so = shell_out('cd /etc; git diff')
      so.stdout
    end
  end
end
