# Encoding: UTF-8
#
# Cookbook Name:: vmware_fusion
# Library:: resource_vmware_fusion
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A parent Chef resource for VMWare Fusion's app and config.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusion < Resource::LWRPBase
      self.resource_name = :vmware_fusion
      actions :install, :remove, :configure
      default_action [:install, :configure]

      #
      # Attribute for an optional specific package URL.
      #
      attribute :source, kind_of: String, default: nil

      #
      # Attribute for an optional VMware Fusion license key
      #
      attribute :license, kind_of: String, default: nil
    end
  end
end
