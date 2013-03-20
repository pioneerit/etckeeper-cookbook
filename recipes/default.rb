#
# Cookbook Name:: etckeeper
# Recipe:: default
#
# Copyright 2013, Alexander Saharchuk.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node[:etckeeper][:packages].each do |pckg|
  package pckg
end

template "#{node[:etckeeper][:config]}" do
    source "etckeeper.conf.erb"
    mode 0644
end

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

cookbook_file "/root/.ssh/etckeeper_key.pub" do
  source "etckeeper_key.pub"
  mode "0644"
  action :create_if_missing
end

template "/root/.ssh/config" do
  source "config_ssh.erb"
  mode "0600"
end

include_recipe "cron"

template "/etc/cron.daily/etckeeper" do
  source "etckeeper.erb"
  mode "0755"
  owner "root"
end

bash "init_repo" do
  user "root"
  cwd "/etc"
  code <<-EOH
  etckeeper init
  etckeeper commit \"Initial commit\"
  git remote add origin #{node[:etckeeper][:git_host]}:etckeeper
  git checkout -b #{node[:fqdn]}
  git push origin #{node[:fqdn]}
  EOH
  not_if do
    File.directory?("/etc/.git")
  end
end

template "#{node[:etckeeper][:dir]}/post-install.d/vcs-commit-push60" do
  source "vcs-commit-push.erb"
  mode "0755"
end
