# encoding: utf-8

require_relative '../spec_helper'

describe 'vmware-fusion::default' do
  let(:platform) { { platform: 'mac_os_x', version: '10.10' } }
  let(:overrides) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      overrides.each { |k, v| node.set['vmware_fusion'][k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any attribute set' do
    it 'installs VMWare Fusion' do
      expect(chef_run).to install_vmware_fusion('default')
        .with(license: overrides[:license], source: overrides[:source])
    end

    it 'configures VMware Fusion' do
      expect(chef_run).to configure_vmware_fusion('default')
        .with(license: overrides[:license], source: overrides[:source])
    end
  end

  context 'all default attributes' do
    let(:overrides) { {} }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden license attribute' do
    let(:overrides) { { license: 'abc123' } }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden source attribute' do
    let(:overrides) { { source: '/path/to/vmware.dmg' } }

    it_behaves_like 'any attribute set'
  end
end
