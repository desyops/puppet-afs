# PRIVATE CLASS: Do not call directly
class afs::client::install {
  $package_name      = $afs::client::package_name
  $krb5_package_name = $afs::client::krb5_package_name
  $dkms_package_name = $afs::client::dkms_package_name

  package { 'openafs-client':
    ensure => installed,
    name   => $package_name,
  }

  package { $krb5_package_name:
    ensure => installed,
  }

  if undef != $dkms_package_name {
    package { $dkms_package_name:
      ensure => installed,
    }
  }

}
