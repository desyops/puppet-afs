# == Class: afs::client
#
# This class manages and installs the OpenAFS client
# See README.md for more details
#
class afs::client (
  $cell                = $afs::params::cell,
  $afs_mount_point     = $afs::params::afs_mount_point,
  $client_cache_dir    = $afs::params::client_cache_dir,
  $client_cache_size   = $afs::params::client_cache_size,
  $afs_sysname         = $afs::params::afs_sysname,

  $config_path         = $afs::params::config_path,
  $client_package_name = $afs::params::client_package_name,
  $krb5_package_name   = $afs::params::krb5_package_name,
  $client_service_name = $afs::params::client_service_name,
) inherits afs::params {

  anchor {'afs::client::begin': } ->
  class {'::afs::client::install': } ->
  class {'::afs::client::config': } ~>
  class {'::afs::client::service': } ->
  anchor {'afs::client::end': }
}
