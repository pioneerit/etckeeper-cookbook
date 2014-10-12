# encoding: UTF-8
#
# Cookbook Name:: etckeeper
# Recipe:: commit
#
# Copyright 2012-2013, Steffen Gebert / TYPO3 Association
#                      Peter Niederlag / TYPO3 Association
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
#

include_recipe 'chef_handler::default'

# clean up after old etckeeper recipe (<1.0.3)
file '/etc/chef/client.d/etckeeper-handler.rb' do
  action :delete
end

template "#{node['chef_handler']['handler_path']}/etckeeper_handler.rb" do
  source 'chef-client/etckeeper_handler.rb'
end

# We register ourself as a report handler, which runs at the end of chef run
chef_handler 'Etckeeper::CommitHandler' do
  source "#{node['chef_handler']['handler_path']}/etckeeper_handler.rb"
  action :enable
  supports report: true, exception: true
end

chef_handler 'Etckeeper::StartHandler' do
  source "#{node['chef_handler']['handler_path']}/etckeeper_handler.rb"
  action :enable
  supports start: true
end
