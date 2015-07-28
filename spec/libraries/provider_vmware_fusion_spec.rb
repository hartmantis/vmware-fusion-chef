# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vmware_fusion'

describe Chef::Provider::VmwareFusion do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VmwareFusion.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/VMware Fusion.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    it 'uses a vmware_fusion_app to install VMF' do
      p = provider
      expect(p).to receive(:vmware_fusion_app).with(name).and_yield
      expect(p).to receive(:action).with(:install)
      p.action_install
    end
  end

  describe '#action_configure' do
    let(:license) { nil }
    let(:new_resource) do
      r = super()
      r.license(license) unless license.nil?
      r
    end

    shared_examples_for 'any resource' do
      it 'uses a vmware_fusion_config to configure VMF' do
        p = provider
        expect(p).to receive(:vmware_fusion_config).with(name).and_yield
        expect(p).to receive(:license).with(license)
        expect(p).to receive(:action).with(:configure)
        p.action_configure
      end
    end

    context 'an all-default resource' do
      it_behaves_like 'any resource'
    end

    context 'a resource with a given license key' do
      let(:license) { 'abc123' }

      it_behaves_like 'any resource'
    end
  end

  describe '#action_remove' do
    it 'uses a vmware_fusion_app to remove VMF' do
      p = provider
      expect(p).to receive(:vmware_fusion_app).with(name).and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end
  end
end
