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
    # Libraries are loaded for every cookbook in the run's dependency graph,
    # even when no etckeeper recipe is in the run_list. Only enforce the /etc
    # sanity check (and mark the run with IN_CHEF for the etckeeper hooks) when
    # an etckeeper recipe is actually part of this run, so we never abort
    # unrelated chef-client runs that merely depend on this cookbook.
    node = Chef.run_context.node
    etckeeper_recipe = lambda do |name|
      name = name.to_s
      name == 'etckeeper' || name.start_with?('etckeeper::')
    end
    in_etckeeper_run =
      Array(node['recipes']).any? { |r| etckeeper_recipe.call(r) } ||
      node.run_list.any? { |item| etckeeper_recipe.call(item.name) }

    if in_etckeeper_run
      Etckeeper::Handler.new.check_etckeeper_before_run
      ENV['IN_CHEF'] = '1'
    end
  end
end
