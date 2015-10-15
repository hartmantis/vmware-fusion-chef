# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vmware_fusion_config'

describe Chef::Provider::VmwareFusionConfig do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) do
    Chef::Resource::VmwareFusionConfig.new(name, run_context)
  end
  let(:provider) { described_class.new(new_resource, run_context) }

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

  describe '#action_create' do
    it 'aliases to the execute resource #action_run method' do
      expect_any_instance_of(described_class).to receive(:converge_by)
      provider.action_create
    end
  end

  describe '#command' do
    let(:license) { nil }
    let(:new_resource) do
      r = super()
      r.license(license) unless license.nil?
      r
    end

    context 'a resource without a license' do
      let(:license) { nil }

      it 'returns the license-less command' do
        expected = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
                   "Initialize\\ VMware\\ Fusion.tool set '' '' '' ''"
        expect(provider.send(:command)).to eq(expected)
      end
    end

    context 'a resource with a license' do
      let(:license) { 'abc123' }

      it 'returns the licensed command' do
        expected = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
                   "Initialize\\ VMware\\ Fusion.tool set '' '' '' 'abc123'"
        expect(provider.send(:command)).to eq(expected)
      end
    end
  end

  describe '#description' do
    let(:license) { nil }
    let(:new_resource) do
      r = super()
      r.license(license) unless license.nil?
      r
    end

    context 'a resource without a license' do
      let(:license) { nil }

      it 'returns the regular output' do
        expected = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
                   "Initialize\\ VMware\\ Fusion.tool set '' '' '' ''"
        expect(provider.send(:description)).to eq(expected)
      end
    end

    context 'a resource with a license' do
      let(:license) { 'abc123' }

      it 'returns with the redacted license' do
        expected = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
                   'Initialize\\ VMware\\ Fusion.tool set ' \
                   "'' '' '' '#{'*' * 16}'"
        expect(provider.send(:description)).to eq(expected)
      end
    end
  end
end
