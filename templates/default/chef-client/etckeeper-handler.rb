require 'rubygems'
require 'chef/log'

module Etckeeper

  # THIS PART IS CURRENTLY NOT USED!!
  class StartHandler < Chef::Handler
    def report
      Chef::Log.info "Etckeeper::StartHandler inspecting /etc"

      if is_git_repo?
        if unclean?
          Chef::Application.fatal! "/etc is NOT clean"
        else
          Chef::Log.info "/etc seems clean, continuing"
        end

      else
        Chef::Log.warn "/etc seems to be not a git repositry"
      end
    end

    def is_git_repo?
      `cd /etc; git status 2>&1`
      return $?.success?
    end

    def unclean?
      `etckeeper unclean`
      return $?.success?
    end
  end


  class CommitHandler < Chef::Handler
    def report
      Chef::Log.info "Persisting changes of current chef run for /etc/"

      # only commit when status is success ???
      message = "chef-client on #{node.name}: " + (run_status.success? ? 'success' : 'failed') +
      "\nFormatted Exception: #{run_status.formatted_exception}" +
      ("\nUpdated resources: #{run_status.updated_resources.join("\n")}")

      Chef::Log.debug `etckeeper commit "#{message}"`
    end
  end

end
