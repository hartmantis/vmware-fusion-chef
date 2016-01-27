# Encoding: UTF-8
#
# Cookbook Name:: vmware_fusion
# Library:: resource_vmware_fusion
#
# Copyright 2015-2016, Jonathan Hartman
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

require 'chef/resource'
require_relative 'resource_vmware_fusion_app'
require_relative 'resource_vmware_fusion_config'

class Chef
  class Resource
    # A parent Chef resource for VMWare Fusion's app and config.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusion < Resource
      PATH ||= '/Applications/VMware Fusion.app'

      provides :vmware_fusion, platform_family: 'mac_os_x'

      default_action [:install, :configure]

      #
      # Property for an optional specific package URL.
      #
      property :source, kind_of: String, default: nil

      #
      # Property for an optional VMware Fusion license key.
      #
      property :license, kind_of: String, default: nil

      #
      # Use the vmware_fusion_app resource to install the app.
      #
      action :install do
        vmware_fusion_app new_resource.name do
          source new_resource.source
        end
      end

      #
      # Use the vmware_fusion_config resource to configure VMware Fusion.
      #
      action :configure do
        vmware_fusion_config new_resource.name do
          license new_resource.license
        end
      end

      #
      # Use the vmware_fusion_app resource to remove the app.
      #
      action :remove do
        vmware_fusion_app new_resource.name do
          action :remove
        end
      end

      #
      # Override resource's text rendering to remove license strings.
      #
      # (see Chef::Resource#to_text)
      #
      def to_text
        license.nil? ? super : super.gsub(license, '*' * 16)
      end
    end
  end
end
