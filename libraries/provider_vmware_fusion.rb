# Encoding: UTF-8
#
# Cookbook Name:: vmware-fusion
# Library:: provider_vmware_fusion
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

require 'net/http'
require 'chef/provider/lwrp_base'
require_relative 'resource_vmware_fusion'
require_relative 'resource_vmware_fusion_app'
require_relative 'resource_vmware_fusion_config'

class Chef
  class Provider
    # A Chef provider for VMWare Fusion.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusion < Provider::LWRPBase
      PATH ||= '/Applications/VMware Fusion.app'

      use_inline_resources

      provides :vmware_fusion, platform_family: 'mac_os_x'

      #
      # WhyRun is supported by this provider.
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Use the vmware_fusion_app resource to install the app.
      #
      action :install do
        vmware_fusion_app new_resource.name do
          action :install
        end
      end

      #
      # Use the vmware_fusion_config resource to configure VMware Fusion.
      #
      action :configure do
        vmware_fusion_config new_resource.name do
          license new_resource.license
          action :configure
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
    end
  end
end
