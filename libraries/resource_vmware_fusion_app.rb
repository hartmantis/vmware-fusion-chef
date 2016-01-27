# Encoding: UTF-8
#
# Cookbook Name:: vmware_fusion
# Library:: resource_vmware_fusion_app
#
# Copyright 2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/http'
require 'chef/resource'

class Chef
  class Resource
    # A Chef resource for the VMWare Fusion app.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusionApp < Resource
      URL ||= 'https://www.vmware.com/go/try-fusion-en'

      provides :vmware_fusion_app, platform_family: 'mac_os_x'

      default_action :install

      #
      # Property for an optional specific package URL.
      #
      property :source, kind_of: [String, nil], default: nil

      #
      # Use a dmg_package resource to download and install the app.
      #
      action :install do
        dmg_package 'VMware Fusion' do
          source new_resource.source || URL
          action :install
        end
      end

      #
      # Remove the app.
      #
      action :remove do
        execute "killall 'VMware Fusion'" do
          ignore_failure true
        end
        [::File.expand_path('~/Library/Application Support/VMware Fusion'),
         ::File.expand_path(VmwareFusion::PATH)].each do |d|
          directory d do
            recursive true
            action :delete
          end
        end
      end
    end
  end
end
