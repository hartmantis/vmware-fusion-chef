# Encoding: UTF-8
#
# Cookbook Name:: vmware-fusion
# Library:: matchers
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

if defined?(ChefSpec)
  [:vmware_fusion, :vmware_fusion_app, :vmware_fusion_config].each do |m|
    ChefSpec.define_matcher(m)
  end

  [:install, :remove, :configure].each do |a|
    define_method("#{a}_vmware_fusion") do |name|
      ChefSpec::Matchers::ResourceMatcher.new(:vmware_fusion, a, name)
    end
  end

  [:install, :remove].each do |a|
    define_method("#{a}_vmware_fusion_app") do |name|
      ChefSpec::Matchers::ResourceMatcher.new(:vmware_fusion_app, a, name)
    end
  end

  [:configure].each do |a|
    define_method("#{a}_vmware_fusion_config") do |name|
      ChefSpec::Matchers::ResourceMatcher.new(:vmware_fusion_config, a, name)
    end
  end
end
