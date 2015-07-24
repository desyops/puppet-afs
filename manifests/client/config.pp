#PRIVATE CLASS: Do not call directly
class afs::client::config {
  $cell            = $afs::client::cell
  $afs_mount_point = $afs::client::afs_mount_point
  $cache_dir       = $afs::client::cache_dir
  $cache_size      = $afs::client::cache_size
  $sysname         = $afs::client::sysname
  $options         = $afs::client::options
  $config_path     = $afs::client::config_path

  $options_real = any2array($options)

  if $cell {
    file {'ThisCell':
      ensure  => present,
      path    => "${config_path}/ThisCell",
      content => "${cell}\n",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Scientific': {
          file {'afs.conf':
            ensure  => present,
            path    => '/etc/sysconfig/afs',
            content => template('afs/afs.conf.rhel.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
          }
        }
        'RedHat': {
          file {'afs.conf':
            ensure  => present,
            path    => '/etc/sysconfig/openafs',
            content => template('afs/afs.conf.rhel.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
          }
        }
        default: { }
      }
    }
    'Debian': {
      file {'afs.conf':
        ensure  => present,
        path    => "${config_path}/afs.conf",
        content => template('afs/afs.conf.debian.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
      }

      file {'afs.conf.client':
        ensure  => present,
        path    => "${config_path}/afs.conf.client",
        content => template('afs/afs.conf.client.debian.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
      }

      # ${config_path}/cacheinfo file is not generated
      # on daemon startup on Debian/Ubuntu
      file {'cacheinfo':
        ensure  => present,
        path    => "${config_path}/cacheinfo",
        content => template('afs/cacheinfo.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
      }
    }
    default: { }
  }
}
