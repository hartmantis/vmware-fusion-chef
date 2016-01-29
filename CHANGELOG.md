VMware Fusion Cookbook CHANGELOG
================================

v1.0.0 (2016-01-29)
-------------------
- Convert to Chef custom resources (breaking compatibility with Chef < 12 and
  requiring the compat_resource cookbook for Chef < 12.5)
- Merge `vmware_fusion` resource's `:configure` action into `:install`

v0.2.0 (2015-08-25)
-------------------
- Support a `source` attribute for specific .dmg package paths

v0.1.1 (2015-08-01)
-------------------
- Redact license keys from log output

v0.1.0 (2015-07-28)
-------------------
- Initial release!

v0.0.1 (2015-07-09)
-------------------
- Development started
