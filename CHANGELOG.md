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
