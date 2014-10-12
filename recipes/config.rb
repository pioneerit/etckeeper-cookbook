# encoding: UTF-8

git_cmd = 'git --git-dir=/etc/.git'

template node['etckeeper']['config'] do
  source 'etckeeper.conf.erb'
  mode 0644
end

if node['etckeeper']['use_remote']
  directory '/root/.ssh' do
    owner 'root'
    group 'root'
    mode '0700'
    action :create
  end

  cookbook_file '/root/.ssh/etckeeper_key' do
    source 'etckeeper_key'
    mode '0600'
    action :create_if_missing
  end

  template '/root/.ssh/config' do
    source 'config_ssh.erb'
    mode '0600'
  end

  origin = "#{node['etckeeper']['git_host']}:#{node['etckeeper']['git_repo']}"
  execute "#{git_cmd} remote add origin #{origin}" do
    cwd '/etc'
    not_if "#{git_cmd} config --get remote.origin.url"
  end

  branch = node['etckeeper']['git_branch']
  execute "#{git_cmd} push --set-upstream origin #{branch}" do
    cwd '/etc'
    not_if "#{git_cmd} config --get branch.master.remote"
  end
end

template '/etc/cron.daily/etckeeper' do
  source 'etckeeper.erb'
  mode '0755'
  owner 'root'
  only_if { node['etckeeper']['daily_auto_commits'] }
end
