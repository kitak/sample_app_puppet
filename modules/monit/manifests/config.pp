class nginx::config { 
  file { '/etc/monit.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('monit/monit.conf'),
  }

  $pid_path = "/var/www/rails/sample_app/config/shared/pids/unicorn.pid"
  file { '/etc/monit.d/unicorn':
    ensure  =>  present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('monit/unicorn'),
  }
}
