#PRIVATE CLASS: Do not call directly
class afs::client::service {
  $service_name = $afs::client::service_name

  service { 'afs':
    ensure    => running,
    name      => $service_name,
    hasstatus => false,
    enable    => true,
  }
}
