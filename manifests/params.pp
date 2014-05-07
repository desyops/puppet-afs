# PRIVATE CLASS: Do not call directly
class afs::params {
  $cell = 'example.org'
  $afs_mount_point = '/afs'
  $client_options = ' '

  case $::operatingsystem {
    'Scientific': {
      $client_cache_dir = '/var/cache/afs'
      $client_cache_size = 'AUTOMATIC'
      $sysname = ['amd64_rhel60', 'amd64_linux26']
      $config_path = '/usr/vice/etc'
      $client_package_name = 'openafs-client'
      $krb5_package_name = 'openafs-krb5'
      $client_service_name = 'afs'
      $client_service_status = true
    }
    'Ubuntu': {
      $client_cache_dir = '/var/cache/openafs'
      $client_cache_size = $::afs_cache_size
      $sysname = ['amd64_ubu124', 'amd64_linux26']
      $config_path = '/etc/openafs'
      $client_package_name = 'openafs-client'
      $krb5_package_name = ['openafs-krb5', 'libpam-afs-session']
      $client_service_name = 'openafs-client'
      $client_service_status = false
    }
    'Debian': {
      $client_cache_dir = '/var/cache/openafs'
      $client_cache_size = $::afs_cache_size
      $sysname = ['amd64_ubu124', 'amd64_linux26']
      $config_path = '/etc/openafs'
      $client_package_name = 'openafs-client'
      $krb5_package_name = ['openafs-krb5', 'libpam-afs-session']
      $client_service_name = 'openafs-client'
      $client_service_status = false
    }
    default: {
      fail("${module_name} is not supported on ${::operatingsystem}.")
    }
  }
}
