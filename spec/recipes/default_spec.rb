# encoding: UTF-8

require 'spec_helper'

describe 'etckeeper::default' do

  before do
    git_cmd = 'git --git-dir=/etc/.git'
    stub_command(
      "#{git_cmd} config --get user.email | fgrep -q 'root@fauxhai.local'"
    ).and_return(true)
  end

  cached(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it 'includes the git recipe' do
    expect(chef_run).to include_recipe('git')
  end

  it 'installs etckeeper' do
    expect(chef_run).to install_package('etckeeper')
  end

  it 'deletes an existing bzr directory' do
    expect(chef_run).to delete_directory('/etc/.bzr')
  end

  it 'includes etckeeper::config' do
    expect(chef_run).to include_recipe('etckeeper::config')
  end
end
