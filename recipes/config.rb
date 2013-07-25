template node['etckeeper']['config'] do
    source "etckeeper.conf.erb"
    mode 0644
end

if node['etckeeper']['git_remote_enabled']
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

  template "#{node['etckeeper']['dir']}/post-install.d/vcs-commit-push60" do
    source "vcs-commit-push.erb"
    mode "0755"
  end
end


template "#{node['etckeeper']['dir']}/cron_task" do
  source "etckeeper.erb"
  mode "0755"
  owner "root"
end

include_recipe "cron"

cron_d "daily-usage-report" do
  minute 0
  hour 2
  command "#{node['etckeeper']['dir']}/cron_task"
  user "root"
end

bash "init_repo" do
  user "root"
  cwd "/etc"
  if node['etckeeper']['git_remote_enabled']
    git_remote = <<-EOF
      git remote add origin #{node['etckeeper']['git_host']}:#{node['etckeeper']['git_repo']}
      git checkout -b #{node['etckeeper']['git_branch']}
      git push origin #{node['etckeeper']['git_branch']}
    EOF
  else
    git_remote = nil
  end
  code <<-EOH
  etckeeper init
  etckeeper commit \"Initial commit\"
  #{git_remote}
  #{node['etckeeper']['dir']}/cron_task
  EOH
  not_if do
    File.directory?("/etc/.git")
  end
end

