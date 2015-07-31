# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_vmware_fusion_config'

describe Chef::Resource::VmwareFusionConfig do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:vmware_fusion_config)
    end

    it 'sets the correct supported actions' do
      expect(resource.allowed_actions).to eq([:nothing, :configure])
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:configure])
    end
  end

  describe '#license' do
    let(:license) { nil }
    let(:resource) do
      r = super()
      r.license(license) if license
      r
    end

    context 'default attribute' do
      let(:source) { nil }

      it 'defaults to nil' do
        expect(resource.license).to eq(nil)
      end
    end

    context 'a valid override' do
      let(:license) { 'abc123' }

      it 'returns the override' do
        expect(resource.license).to eq('abc123')
      end
    end

    context 'an invalid override' do
      let(:license) { :elsewhere }

      it 'raises an error' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#to_text' do
    let(:license) { nil }
    let(:resource) do
      r = super()
      r.license(license) if license
      r
    end

    context 'no license attribute' do
      let(:license) { nil }

      it 'does not change anything' do
        expect(resource.to_text).not_to include('license')
      end
    end

    context 'a license attribute' do
      let(:license) { 'abc123' }

      it 'sanitizes the license field' do
        expect(resource.to_text).to include('license "****************"')
      end
    end
  end
end
