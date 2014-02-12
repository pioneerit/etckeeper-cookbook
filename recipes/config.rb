template node['etckeeper']['config'] do
  source "etckeeper.conf.erb"
  mode 0644
end

if node['etckeeper']['use_remote']
  directory "/root/.ssh" do
    owner "root"
    group "root"
    mode "0700"
    action :create
  end

  cookbook_file "/root/.ssh/etckeeper_key" do
    source "etckeeper_key"
    mode "0600"
    action :create_if_missing
  end

  template "/root/.ssh/config" do
    source "config_ssh.erb"
    mode "0600"
  end

  execute "git remote add origin #{node['etckeeper']['git_host']}:#{node['etckeeper']['git_repo']}" do
    cwd '/etc'
    not_if 'git config --get remote.origin.url'
  end

  execute "git push --set-upstream origin #{node['etckeeper']['git_branch']}" do
    cwd '/etc'
    not_if 'git config --get branch.master.remote'
  end
end

if node['etckeeper']['daily_auto_commits']
  template "/etc/cron.daily/etckeeper" do
    source "etckeeper.erb"
    mode "0755"
    owner "root"
  end
end
