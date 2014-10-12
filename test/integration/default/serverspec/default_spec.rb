# encoding: utf-8

require 'spec_helper'

describe 'etckeeper' do
  describe package('etckeeper') do
    it { should be_installed }
  end
end
