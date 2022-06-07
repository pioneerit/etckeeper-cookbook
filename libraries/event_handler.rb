#
# Chef Infra Documentation
# https://docs.chef.io/libraries/
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

module Etckeeper
  class Handler
    def check_etckeeper_before_run
      ::Chef::Log.info 'Etckeeper::Sanity checks => inspecting /etc'
      if Etckeeper::Helpers.git_repo?
        if Etckeeper::Helpers.unclean?
          ::Chef::Log.error(
            'Found changes to /etc: ' + "\n>> #{Etckeeper::Helpers.git_diff}"
          )
          raise('/etc is NOT clean. Stopping chef-run')
        else
          ::Chef::Log.debug '/etc seems clean, continuing'
        end
      else
        ::Chef::Log.warn '/etc seems to be not a Git repositry'
      end
    end
  end

  class Helpers
    extend Chef::Mixin::ShellOut

    def self.git_repo?
      ::File.directory?('/etc/.git')
    end

    def self.unclean?
      so = shell_out('etckeeper unclean')
      so.exitstatus == 0
    end

    def self.git_diff
      so = shell_out('cd /etc; git status --porcelain')
      so.stdout.split("\n").join("\n>> ")
    end
  end
end

Chef.event_handler do
  on :library_load_complete do
    Etckeeper::Handler.new.check_etckeeper_before_run
  end
end
