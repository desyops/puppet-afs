# == Class: afs::client
#
# This class manages and installs the OpenAFS client
# See README.md for more details
#
class afs::client (
  $cell              = $afs::params::cell,
  $afs_mount_point   = $afs::params::afs_mount_point,
  $cache_dir         = $afs::params::client_cache_dir,
  $cache_size        = $afs::params::client_cache_size,
  $sysname           = $afs::params::sysname,

  $config_path       = $afs::params::config_path,
  $package_name      = $afs::params::client_package_name,
  $krb5_package_name = $afs::params::krb5_package_name,
  $service_name      = $afs::params::client_service_name,
) inherits afs::params {

  anchor {'afs::client::begin': } ->
  class {'::afs::client::install': } ->
  class {'::afs::client::config': } ~>
  class {'::afs::client::service': } ->
  anchor {'afs::client::end': }
}
