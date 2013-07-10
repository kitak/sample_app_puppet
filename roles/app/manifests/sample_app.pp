class app::sample_app {
  package { "mysql-devel":
    ensure => installed,
  }
  
  file { '/etc/init.d/unicorn':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('app/unicorn_ini.sh'),
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
