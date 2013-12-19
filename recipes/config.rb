template node['etckeeper']['config'] do
    source "etckeeper.conf.erb"
    mode 0644
end

if node['etckeeper']['use_remote']
  directory "/root/.ssh" do
    owner "root"
    group "root"
    mode "0755"
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

  template "#{node['etckeeper']['dir']}/commit.d/60vcs-commit-push" do
    source "60vcs-commit-push.erb"
    mode "0755"
  end

  template "/etc/cron.daily/etckeeper" do
    source "etckeeper.erb"
    mode "0755"
    owner "root"
  end
end

if ! node['etckeeper']['use_remote']
  file "#{node['etckeeper']['dir']}/commit.d/60vcs-commit-push" do
    action :delete
  end
end