# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_vmware_fusion'

describe Chef::Resource::VmwareFusion do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:vmware_fusion)
    end

    it 'sets the correct supported actions' do
      expected = [:nothing, :install, :remove, :configure]
      expect(resource.allowed_actions).to eq(expected)
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:install, :configure])
    end
  end

  describe '#source' do
    let(:source) { nil }
    let(:resource) do
      r = super()
      r.source(source) if source
      r
    end

    context 'default attribute' do
      let(:source) { nil }

      it 'defaults to nil' do
        expect(resource.source).to eq(nil)
      end
    end

    context 'a valid override' do
      let(:source) { 'http://example.com/vmw.dmg' }

      it 'returns the override' do
        expect(resource.source).to eq('http://example.com/vmw.dmg')
      end
    end

    context 'an invalid override' do
      let(:source) { :elsewhere }

      it 'raises an error' do
        expect { resource }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
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

  describe '#sensitive' do
    let(:license) { nil }
    let(:resource) do
      r = super()
      r.license(license) if license
      r
    end

    context 'no license attribute' do
      let(:license) { nil }

      it 'returns false' do
        expect(resource.sensitive).to eq(false)
      end
    end

    context 'a license attribute' do
      let(:license) { 'abc123' }

      it 'returns true' do
        expect(resource.sensitive).to eq(true)
      end
    end
  end

  describe '#to_text' do
    let(:resource) do
      r = super()
      r.license('abc123')
      r
    end

    it 'suppresses sensitive information' do
      expected = 'suppressed sensitive resource output'
      expect(resource.to_text).to eq(expected)
    end
  end
end
