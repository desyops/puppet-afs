#PRIVATE CLASS: Do not call directly
class afs::client::service {
  $service_name   = $afs::client::service_name
  $service_status = $afs::client::service_status
  $manage_service = str2bool($afs::client::manage_service)

  if $manage_service {
    service { 'afs':
      ensure    => running,
      name      => $service_name,
      hasstatus => $service_status,
      enable    => true,
      pattern   => '/sbin/afsd'
    }
  }
}
