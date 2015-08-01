# Encoding: UTF-8
#
# Cookbook Name:: vmware_fusion
# Library:: resource_vmware_fusion_config
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

require 'chef/resource/execute'

class Chef
  class Resource
    # A Chef resource for VMware Fusion configuration. Since that config is
    # just an initialization script, build based off an execute resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusionConfig < Resource::Execute
      self.resource_name = :vmware_fusion_config
      self.allowed_actions = [:nothing, :create]
      default_action :create

      #
      # Add an attribute for an optional VMware Fusion license key.
      #
      # @return [NilClass, String]
      #
      def license(arg = nil)
        set_or_return(:license, arg, kind_of: String, default: nil)
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
