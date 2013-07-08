class monit::config { 
  file { '/etc/monit.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('monit/monit.conf'),
  }

  file { '/etc/init/monit.conf':
    ensure  =>  present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('monit/monit.upstart.conf'),
  }
}
