class app::nginx::config { 
  file { '/etc/nginx/conf.d/unicorn.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app/nginx/unicorn.conf'),
  }
}
