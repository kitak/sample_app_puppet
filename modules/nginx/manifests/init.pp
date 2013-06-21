class nginx () {
  $nginx_packages = [
    'nginx',
  ]

  package { $nginx_packages:
    ensure => installed,
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/templates/nginx.conf'),
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

  service { 'nginx':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    require    => Package['nginx'],
  }

}
