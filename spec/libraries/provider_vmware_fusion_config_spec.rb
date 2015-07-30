# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vmware_fusion_config'

describe Chef::Provider::VmwareFusionConfig do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VmwareFusionConfig.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

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

  describe '#action_configure' do
    let(:license) { nil }
    let(:new_resource) do
      r = super()
      r.license(license) unless license.nil?
      r
    end

    shared_examples_for 'any resource' do
      it 'uses an execute to initialize VMware Fusion' do
        p = provider
        expect(p).to receive(:execute).with('Initialize VMware Fusion')
          .and_yield
        cmd = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
              "Initialize\\ VMware\\ Fusion.tool set '' '' '#{license}'"
        expect(p).to receive(:command).with(cmd)
        expect(p).to receive(:sensitive).with(license.nil? ? false : true)
        expect(p).to receive(:action).with(:run)
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
end
