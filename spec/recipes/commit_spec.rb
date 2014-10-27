# encoding: UTF-8

require 'spec_helper'

describe 'etckeeper::commit' do

  cached(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it 'deletes the chef-handler include from the old cookbook' do
    expect(chef_run).to delete_file('/etc/chef/client.d/etckeeper-handler.rb')
  end

  it 'installs the handler code' do
    expect(chef_run).to create_template(
      "#{chef_run.node['chef_handler']['handler_path']}/etckeeper_handler.rb"
    )
  end

  it 'registers a start handler' do
    expect(chef_run).to enable_chef_handler('Etckeeper::StartHandler')
      .with(supports: { start: true })
  end

  it 'registers a report handler' do
    expect(chef_run).to enable_chef_handler('Etckeeper::CommitHandler')
      .with(supports: { report: true, exception: true })
  end
end
