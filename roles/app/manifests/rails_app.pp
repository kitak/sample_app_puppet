class app::rails_app {
  
  file { '/etc/init.d/unicorn':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('app/unicorn_ini.sh'),
  }

  file { '/var/www/rails':
    ensure => directory,
    owner => 'app',
    group => 'app',
    mode => '0755'
  }

} 
