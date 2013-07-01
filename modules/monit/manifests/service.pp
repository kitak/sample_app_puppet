class monit::service {
  service { 'monit':
    enable     => true,
    ensure     => running,
    hasrestart => true,
  }
}
