require_relative '../../../spec_helper'

describe 'resource_vmware_fusion_config::mac_os_x::10_10' do
  let(:license) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vmware_fusion_config',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['vmware_fusion']['license'] = license unless license.nil?
    end
  end
  let(:converge) do
    runner.converge("resource_vmware_fusion_config_test::#{action}")
  end

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any property set' do
      it 'runs the VMware Fusion initialize script' do
        cmd = '/Applications/VMware\\ Fusion.app/Contents/Library/' \
              "Initialize\\ VMware\\ Fusion.tool set '' '' '' '#{license}'"
        expect(chef_run).to run_execute('Initialize VMware')
          .with(command: cmd, sensitive: !license.nil?)
      end
    end

    context 'all default properties' do
      cached(:chef_run) { converge }

      it_behaves_like 'any property set'
    end

    context 'an overridden license property' do
      let(:license) { 'abc123' }
      cached(:chef_run) { converge }

      it_behaves_like 'any property set'

      it 'sanitizes the license field in the log' do
        r = chef_run.vmware_fusion_config('default')
        expect(r.to_text).to include('license "****************"')
      end
    end
  end
end
