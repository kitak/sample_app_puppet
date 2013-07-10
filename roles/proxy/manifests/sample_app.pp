class proxy::sample_app {
  package { "mysql-devel":
    ensure => installed,
  }
  
  file { '/var/www':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0755',
  }

  file { '/var/www/rails':
    ensure => directory,
    owner => 'app',
    group => 'app',
    mode => '0755', 
    require => File['/var/www'],
  }
}
