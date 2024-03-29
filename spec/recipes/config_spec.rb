require 'spec_helper'

describe 'etckeeper::config' do
  git_cmd = 'git --git-dir=/etc/.git'

  before do
    stub_command(
      "#{git_cmd} config --get user.email | fgrep -q 'root@fauxhai.local'"
    ).and_return(true)
    stub_command("#{git_cmd} config --get remote.origin.url")
      .and_return('something')
    stub_command("#{git_cmd} config --get branch.master.remote")
      .and_return('something')
  end

  it 'creates the etckeeper config file' do
    is_expected.to render_file('/etc/etckeeper/etckeeper.conf')
  end

  context 'without existing git repository' do
    before do
      allow(File).to receive(:exist?)
        .and_call_original
      allow(File).to receive(:exist?)
        .with('/etc/.git/config')
        .and_return(false)
    end

    cached(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'runs "etckeeper init"' do
      is_expected.to run_execute('etckeeper init')
    end
  end

  context 'with existing git repository' do
    before do
      allow(File).to receive(:exist?)
        .and_call_original
      allow(File).to receive(:exist?)
        .with('/etc/.git/config')
        .and_return(true)
    end

    cached(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'does not run "etckeeper init" again' do
      is_expected.not_to run_execute('etckeeper init')
    end
  end

  context 'with attribute push git' do
    default_attributes['etckeeper']['git_host'] = 'github.com'
    default_attributes['etckeeper']['git_port'] = 22
    default_attributes['etckeeper']['git_repo'] = 'etckeeper'
    before do
      stub_command("#{git_cmd} config --get remote.origin.url")
        .and_return(false)
      stub_command("#{git_cmd} config --get branch.master.remote")
        .and_return(false)
    end

    it 'creates directory /root/.ssh' do
      is_expected.to create_directory('/root/.ssh')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0700')
    end

    it 'creates the etckeeper ssh key' do
      is_expected.to create_cookbook_file_if_missing(
        '/root/.ssh/etckeeper_key'
      ).with(mode: '0600')
    end

    it 'creates /root/.ssh/config' do
      is_expected.to create_template('/root/.ssh/config')
        .with(mode: '0600')
      is_expected.to render_file('/root/.ssh/config')
        .with_content(/^Host #{chef_run.node['etckeeper']['git_host']}$/)
        .with_content(/^\s+user\s+git$/)
        .with_content(/^\s+Port\s+#{chef_run.node['etckeeper']['git_port']}$/)
        .with_content(/^\s+StrictHostKeyChecking\s+no$/)
        .with_content(%r{^\s+IdentityFile\s+/root/.ssh/etckeeper_key$})
    end

    context 'without email address in git config' do
      default_attributes['etckeeper']['git_email'] = 'x@example.com'
      before do
        stub_command(
          "#{git_cmd} config --get user.email | fgrep -q 'x@example.com'"
        ).and_return(false)
      end

      it 'adds the email to git config' do
        is_expected.to run_execute('etckeeper_set_git_email')
          .with(command: "#{git_cmd} config user.email 'x@example.com'")
      end
    end

    context 'with existing user info in git config' do
      default_attributes['etckeeper']['git_email'] = 'x@example.com'
      before do
        stub_command(
          "#{git_cmd} config --get user.email | fgrep -q 'x@example.com'"
        ).and_return(true)
      end

      it 'does not set the email again' do
        is_expected.not_to run_execute('etckeeper_set_git_email')
      end
    end

    context 'without set git remote' do
      it 'adds the configured origin' do
        host = chef_run.node['etckeeper']['git_host']
        repo = chef_run.node['etckeeper']['git_repo']
        is_expected.to run_execute(
          "#{git_cmd} remote add origin #{host}:#{repo}"
        )
      end
    end

    context 'with set git remote' do
      default_attributes['etckeeper']['git_host'] = 'github.com'
      default_attributes['etckeeper']['git_port'] = 22
      default_attributes['etckeeper']['git_repo'] = 'etckeeper'
      before do
        stub_command("#{git_cmd} config --get remote.origin.url")
          .and_return('something')
        stub_command("#{git_cmd} config --get branch.master.remote")
          .and_return('something')
      end

      it 'does not change the configured origin' do
        host = chef_run.node['etckeeper']['git_host']
        repo = chef_run.node['etckeeper']['git_repo']
        is_expected.not_to run_execute(
          "#{git_cmd} remote add origin #{host}:#{repo}"
        )
      end
    end

    context 'without set remote git branch' do
      default_attributes['etckeeper']['git_host'] = 'github.com'
      default_attributes['etckeeper']['git_port'] = 22
      default_attributes['etckeeper']['git_repo'] = 'etckeeper'
      before do
        stub_command("#{git_cmd} config --get remote.origin.url")
          .and_return('something')
        stub_command("#{git_cmd} config --get branch.master.remote")
          .and_return(false)
      end

      it 'sets the branch' do
        branch = chef_run.node['etckeeper']['git_branch']
        is_expected.to run_execute(
          "#{git_cmd} push --set-upstream origin #{branch}"
        )
      end
    end

    context 'with existing remote git branch' do
      default_attributes['etckeeper']['git_host'] = 'github.com'
      default_attributes['etckeeper']['git_port'] = 22
      default_attributes['etckeeper']['git_repo'] = 'etckeeper'
      before do
        stub_command("#{git_cmd} config --get remote.origin.url")
          .and_return('something')
        stub_command("#{git_cmd} config --get branch.master.remote")
          .and_return('something')
      end

      it 'does not set the branch' do
        branch = chef_run.node['etckeeper']['git_branch']
        is_expected.not_to run_execute(
          "#{git_cmd} push --set-upstream origin #{branch}"
        )
      end
    end
  end
end
