# PRIVATE CLASS: Do not call directly
class afs::client::install {
  $client_package_name = $afs::client::client_package_name
  $krb5_package_name   = $afs::client::krb5_package_name

  package { 'openafs-client':
    ensure => installed,
    name   => $client_package_name,
  }

  package { $krb5_package_name:
    ensure => installed,
  }
}
