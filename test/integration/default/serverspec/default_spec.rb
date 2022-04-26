require 'spec_helper'

describe 'etckeeper' do
  describe package('etckeeper') do
    it { should be_installed }
  end

  describe file('/etc/.bzr') do
    it { should_not be_directory }
    it { should_not be_file }
  end
end
