class monit::service {
  exec { 'start monit':
    path    => ['/sbin', '/bin'],
    command => 'initctl start monit',
    unless  => 'initctl status monit | grep running',
  }

  exec { 'reload monit':
    path    => ['/sbin', '/bin'],
    command => 'initctl reload monit',
    onlyif  => 'initctl status monit | grep running',
  }
}
