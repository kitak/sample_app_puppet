class app::monit::config {
  $pid_path = "/var/www/rails/sample_app/shared/pids/unicorn.pid"
  file { '/etc/monit.d/unicorn':
    ensure  =>  present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app/monit/unicorn'),
  }
}
