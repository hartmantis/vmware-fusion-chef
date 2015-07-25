# Encoding: UTF-8

require_relative '../spec_helper'

describe 'vmware-fusion::app' do
  describe file('/Applications/VMware Fusion.app') do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end
end
