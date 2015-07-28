# Encoding: UTF-8

require_relative '../spec_helper'

describe 'vmware-fusion::default' do
  let(:overrides) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      overrides && overrides.each { |k, v| node.set['vmware_fusion'][k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'all default attributes' do
    let(:overrides) { nil }

    it 'installs VMWare Fusion' do
      expect(chef_run).to install_vmware_fusion('default').with(license: nil)
    end

    it 'configures VMware Fusion' do
      expect(chef_run).to configure_vmware_fusion('default').with(license: nil)
    end
  end

  context 'an overridden license attribute' do
    let(:overrides) { { license: 'abc123' } }

    it 'installs VMware Fusion' do
      expect(chef_run).to install_vmware_fusion('default')
        .with(license: 'abc123')
    end

    it 'configures VMware Fusion' do
      expect(chef_run).to configure_vmware_fusion('default')
        .with(license: 'abc123')
    end
  end
end
