# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_vmware_fusion_app'

describe Chef::Provider::VmwareFusionApp do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::VmwareFusionApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe 'URL' do
    it 'returns the remote URL' do
      expected = 'https://www.vmware.com/go/try-fusion-en'
      expect(described_class::URL).to eq(expected)
    end
  end

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
    it 'installs and initializes the package' do
      p = provider
      expect(p).to receive(:install_package)
      expect(p).to receive(:initialize_package)
      p.action_install
    end
  end

  describe '#remove!' do
    it 'stops VMware Fusion and deletes its directories' do
      p = provider
      expect(p).to receive(:execute).with("killall 'VMware Fusion'").and_yield
      expect(p).to receive(:ignore_failure).with(true)
      [
        File.expand_path('~/Library/Application Support/VMware Fusion'),
        described_class::PATH
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.action_remove
    end
  end

  describe '#initialize_package' do
    let(:license) { nil }

    shared_examples_for 'any resource' do
      it 'uses an execute to initialize VMware Fusion' do
        p = provider
        expect(p).to receive(:execute).with('Initialize VMware Fusion')
          .and_yield
        cmd = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
              "Initialize\\ VMware\\ Fusion.tool set '' '' '#{license}'"
        expect(p).to receive(:command).with(cmd)
        expect(p).to receive(:action).with(:nothing)
        p.send(:initialize_package)
      end
    end

    context 'an all-default resource' do
      it_behaves_like 'any resource'
    end

    context 'a resource with a given license key' do
      let(:license) { 'abc123' }
      let(:new_resource) do
        r = super()
        r.license(license)
        r
      end

      it_behaves_like 'any resource'
    end
  end

  describe '#install_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:package_source)
        .and_return('https://example.com/vmwf.dmg')
    end

    it 'uses a dmg_package to install VMware Fusion' do
      p = provider
      expect(p).to receive(:dmg_package).with('VMware Fusion').and_yield
      expect(p).to receive(:source).with('https://example.com/vmwf.dmg')
      expect(p).to receive(:action).with(:install)
      expect(p).to receive(:notifies).with(:run,
                                           'execute[Initialize VMware Fusion]')
      p.send(:install_package)
    end
  end

  describe '#package_source' do
    let(:location) { 'https://example.com/vmwf.dmg' }

    before(:each) do
      caf = Chef::Config[:ssl_ca_file]
      allow(Net::HTTP).to receive(:start)
        .with('www.vmware.com', 443, use_ssl: true, ca_file: caf)
        .and_return('location' => location)
    end

    it 'returns a download URL' do
      expected = 'https://example.com/vmwf.dmg'
      expect(provider.send(:package_source)).to eq(expected)
    end
  end
end
