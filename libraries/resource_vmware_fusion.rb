# encoding: utf-8
# frozen_string_literal: true
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
      PATH = '/Applications/VMware Fusion.app'.freeze unless defined?(PATH)

      provides :vmware_fusion, platform_family: 'mac_os_x'

      default_action :install

      #
      # Merge in the properties from the vmware_fusion_app and
      # vmware_fusion_config resources.
      #
      VmwareFusionApp.properties.each { |k, v| property k, v }
      VmwareFusionConfig.properties.each { |k, v| property k, v }

      #
      # Install the VMware Fusion app and configure the license.
      #
      action :install do
        vmware_fusion_app new_resource.name do
          VmwareFusionApp.properties.keys.each do |k|
            send(k, new_resource.send(k))
          end
        end
        vmware_fusion_config new_resource.name do
          VmwareFusionConfig.properties.keys.each do |k|
            send(k, new_resource.send(k))
          end
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
