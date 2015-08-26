# Encoding: UTF-8
#
# Cookbook Name:: vmware-fusion
# Library:: provider_vmware_fusion_app
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
require_relative 'provider_vmware_fusion'
require_relative 'resource_vmware_fusion_app'

class Chef
  class Provider
    # A Chef provider for the VMWare Fusion application itself.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VmwareFusionApp < Provider::LWRPBase
      URL ||= 'https://www.vmware.com/go/try-fusion-en'

      use_inline_resources

      provides :vmware_fusion_app, platform_family: 'mac_os_x'

      #
      # WhyRun is supported by this provider.
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Use a dmg_package resource to download and install the app.
      #
      action :install do
        s = package_source
        dmg_package 'VMware Fusion' do
          source s
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

      private

      #
      # Follow the site redirect to get a .dmg download URL.
      #
      # @return [String] a remote package URL
      #
      def package_source
        @package_source ||= new_resource.source || begin
          u = URI.parse(URL)
          opts = { use_ssl: u.scheme == 'https',
                   ca_file: Chef::Config[:ssl_ca_file] }
          resp = Net::HTTP.start(u.host, u.port, opts) { |h| h.head(u.to_s) }
          resp['location']
        end
      end
    end
  end
end
