VMware Fusion Cookbook
======================
[![Cookbook Version](https://img.shields.io/cookbook/v/vmware-fusion.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/RoboticCheese/vmware-fusion-chef.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/vmware-fusion-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/vmware-fusion-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/vmware-fusion
[travis]: https://travis-ci.org/RoboticCheese/vmware-fusion-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/vmware-fusion-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/vmware-fusion-chef

A Chef cookbook for installing VMware Fusion.

Requirements
============

This cookbook consumes the dmg cookbook to support installing OS X packages.

Usage
=====

Either add the default recipe to your run_list or use the included resource in
a recipe of your own.

Recipes
=======

***default***

Installs VMware Fusion.

Resources
=========

***vmware_fusion_app***

Used to manage the installation of the VMware Fusion app.

Syntax:

    vmware_fusion_app 'default' do
      action :install
    end

Actions:

| Action     | Description       |
|------------|-------------------|
| `:install` | Install the app   |
| `:remove`  | Uninstall the app |

Attributes:

| Attribute  | Default        | Description          |
|------------|----------------|----------------------|
| action     | `:install`     | Action(s) to perform |

Providers
=========

***Chef::Provider::VmwareFusionApp***

Provider for OS X (the only platform VMware Fusion is for).

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
