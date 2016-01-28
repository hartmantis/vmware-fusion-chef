require_relative '../../../spec_helper'

describe 'resource_vmware_fusion::mac_os_x::10_10' do
  let(:source) { nil }
  let(:license) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vmware_fusion',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['vmware_fusion']['source'] = source unless source.nil?
      node.set['vmware_fusion']['license'] = license unless license.nil?
    end
  end
  let(:converge) { runner.converge("resource_vmware_fusion_test::#{action}") }

  context 'the default action ([:install, :configure])' do
    let(:action) { :default }

    shared_examples_for 'any property set' do
      it 'installs the VMware Fusion app' do
        expect(chef_run).to install_vmware_fusion_app('default')
          .with(source: source)
      end

      it 'configures the VMware Fusion license' do
        expect(chef_run).to create_vmware_fusion_config('default')
          .with(license: license)
      end
    end

    context 'all default properties' do
      cached(:chef_run) { converge }

      it_behaves_like 'any property set'
    end

    context 'an overridden source property' do
      let(:source) { 'http://example.com/vmware.dmg' }
      cached(:chef_run) { converge }

      it_behaves_like 'any property set'
    end

    context 'an overridden license property' do
      let(:license) { 'abc123' }
      cached(:chef_run) { converge }

      it_behaves_like 'any property set'

      it 'sanitizes the license field in the log' do
        expected = 'license "****************"'
        expect(chef_run.vmware_fusion('default').to_text).to include(expected)
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the VMware Fusion app' do
      expect(chef_run).to remove_vmware_fusion_app('default')
    end
  end
end
