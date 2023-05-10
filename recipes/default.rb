#
# Cookbook:: etckeeper
# Recipe:: default
#

include_recipe 'git'

include_recipe 'yum-epel::default' if node['platform_family'] == 'rhel'

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

patches_list = %w{
  0001-feat-etckeeper-Add-unstash-for-etckeeper.patch
  0001-feat-etckeeper-Create-a-hook-to-stash-changes-before.patch
}
patches_list.each do |patch_file|
  full_path = ::File.join(::Chef::Config.file_cache_path, patch_file)
  cookbook_file full_path do
    source patch_file
    owner 'root'
    group 'root'
    only_if { node['etckeeper']['config_file']['VCS'] == 'git' }
  end

  execute "etckeeper vcs am #{full_path}" do
    cwd '/etc'
    only_if "etckeeper vcs apply #{full_path} --check"
    only_if { node['etckeeper']['config_file']['VCS'] == 'git' }
    notifies :run, 'execute[etckeeper pre-commit]', :immediate
  end

  execute "Commit updated metastore(#{patch_file})" do
    command "git commit -m 'Updating metastore after applying #{patch_file}'"
    cwd '/etc'
    only_if { node['etckeeper']['config_file']['VCS'] == 'git' }
    not_if 'git diff --staged --exit-code .etckeeper'
    action :nothing
  end
end

execute 'etckeeper pre-commit' do
  action :nothing
  patches_list.each do |patch_file|
    notifies :run, "execute[Commit updated metastore(#{patch_file})]", :immediate
  end
end

include_recipe 'etckeeper::config'
