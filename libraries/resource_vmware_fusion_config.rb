# Encoding: UTF-8
#
# Cookbook Name:: vmware_fusion
# Library:: resource_vmware_fusion_config
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
require_relative 'resource_vmware_fusion'

class Chef
  class Resource
    # A Chef resource for VMware Fusion configuration, aka running the included
    # initialization script to install a license key.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusionConfig < Resource
      provides :vmware_fusion_config, platform_family: 'mac_os_x'

      default_action :create

      #
      # A property for an optional VMware Fusion license key.
      #
      property :license, [String, nil], default: nil

      #
      # Use an execute resource to run the Vmware init tool.
      #
      action :create do
        execute 'Initialize VMware' do
          p = ::File.join(VmwareFusion::PATH,
                          'Contents/Library/Initialize VMware Fusion.tool')
          command "#{p.gsub(' ', '\\ ')} set '' '' '' '#{new_resource.license}'"
          sensitive true if new_resource.license
        end
      end

      #
      # Override resource's text rendering to remove license strings.
      #
      # (see Resource#to_text)
      #
      def to_text
        license.nil? ? super : super.gsub(license, '*' * 16)
      end
    end
  end
end
