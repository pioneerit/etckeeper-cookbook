# encoding: utf-8

require 'spec_helper'

describe 'etckeeper::commit' do
  describe file('/tmp/kitchen/handlers/etckeeper_handler.rb') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:sha256sum) do
      should eq(
        '601620473c3a44d2c05ba4c50117ca6a4631818400aa7743cdc0a59c43188aae'
      )
    end
  end

  describe file('/etc/chef/client.d/etckeeper-handler.rb') do
    it { should_not be_file }
  end

end
