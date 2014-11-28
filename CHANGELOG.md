## 2014-11-28 Release 1.0.1
This release just fixes the incorrect module dependency on puppetlabs-stdlib.
No other changes have been introduced.

## 2014-06-19 Release 1.0.0
Bugfix and feature release. For a full list of changes, see notes
for release 1.0.0-rc.1.

Changes since 1.0.0-rc.1:
* Use str2bool to convert strings into booleans for manage_service parameter

## 2014-05-26 Release 1.0.0-rc.1
Bugfix and feature pre-release
* Add fact `afs_cache_size` to determine cache size for the Debian osfamily
  * See [Limitations](README.md#limitations) for this fact
* Allow configuration of afs client daemon options
* Add configuration for optional afs client service management
* Bump required puppetlabs/stdlib version to >=4.0.0
* Minor documentation update

## 2014-04-02 Release 0.6.1
### Summary:
Bugfix release
* Add service_status variable for unavailable status action in init script
* Add header to puppet managed files

## 2014-04-02 Release 0.6.0
### Summary:
Remove duplicate client prefixes from variables. This more or less breaks
the current exposed API.
For upgrading, removing the *client_* prefix from Hiera or class declarations
should be sufficient.

## 2014-03-07 Release 0.5.0
### Summary:
Initial public release from a previously internal module.
