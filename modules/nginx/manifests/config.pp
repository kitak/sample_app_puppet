class nginx::config { 
  file { '/etc/nginx/conf.d/default.conf':
    ensure =>  absent,
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/nginx.conf'),
  }
}
