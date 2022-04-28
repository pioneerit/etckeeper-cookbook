#
# Cookbook:: etckeeper
# Recipe:: default
#

include_recipe 'git'

package 'etckeeper' do
  action :install
end

# if a .bzr directory exists, etckeeper will use bzr, ignoring the
# configured vcs:
directory '/etc/.bzr' do
  action :delete
  only_if { node['etckeeper']['config_file']['VCS'] == 'git' }
  recursive true
end

include_recipe 'etckeeper::config'
