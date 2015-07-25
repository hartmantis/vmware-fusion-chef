# Encoding: UTF-8

require_relative '../spec_helper'

describe 'vmware-fusion::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs VMWare Fusion' do
    expect(chef_run).to install_vmware_fusion_app('default')
  end
end
