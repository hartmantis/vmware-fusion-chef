require_relative '../../../spec_helper'

describe 'resource_vmware_fusion_app::mac_os_x::10_10' do
  let(:source) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'vmware_fusion_app',
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['vmware_fusion']['source'] = source unless source.nil?
    end
  end
  let(:converge) do
    runner.converge("resource_vmware_fusion_app_test::#{action}")
  end

  context 'the default action (:install)' do
    let(:action) { :default }

    shared_examples_for 'any property set' do
      it 'uses a dmg_package resource to install VMware Fusion' do
        expect(chef_run).to install_dmg_package('VMware Fusion').with(
          source: (source || 'https://www.vmware.com/go/try-fusion-en')
        )
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
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'kills ny running instances of VMware Fusion' do
      exe = "killall 'VMware Fusion'"
      expect(chef_run).to run_execute(exe).with(ignore_failure: true)
    end

    it 'deletes the main app dir' do
      dir = '/Applications/VMware Fusion.app'
      expect(chef_run).to delete_directory(dir).with(recursive: true)
    end

    it 'deletes the app support dir' do
      dir = File.expand_path('~/Library/Application Support/VMware Fusion')
      expect(chef_run).to delete_directory(dir).with(recursive: true)
    end
  end
end
