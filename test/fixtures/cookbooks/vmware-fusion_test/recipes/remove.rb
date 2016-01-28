# encoding: utf-8

include_recipe 'vmware-fusion'

vmware_fusion_app 'default' do
  action :remove
end
