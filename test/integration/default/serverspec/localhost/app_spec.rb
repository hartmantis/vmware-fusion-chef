# encoding: utf-8

require_relative '../spec_helper'

describe 'vmware-fusion::app' do
  describe file('/Applications/VMware Fusion.app') do
    it 'exists' do
      expect(subject).to be_directory
    end
  end
end
