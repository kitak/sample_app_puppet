class proxy::nginx::config { 
  file { '/etc/nginx/conf.d/proxy.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('proxy/nginx/proxy.conf'),
  }
}
