#PRIVATE CLASS: Do not call directly
class afs::client::service {
  $service_name   = $afs::client::service_name
  $service_status = $afs::client::service_status

  service { 'afs':
    ensure    => running,
    name      => $service_name,
    hasstatus => $service_status,
    enable    => true,
    pattern   => '/sbin/afsd'
  }
}
