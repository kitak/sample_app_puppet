class app::user_group {
  user { 'app':
    ensure     => present,
    comment    => 'app',
    home       => '/home/app',
    managehome => true,
    shell      => '/bin/bash',
    uid        => 1000,
    gid        => 'app',
  }

  group { 'app':
    ensure => present,
    gid    => 1000,
  }

  file { '/home/app/.ssh':
    ensure => directory,
    owner => 'app',
    group => 'app',
    mode => '0700',
    require => [User['app'], Group['app']],
  }

  file { '/home/app/.ssh/authorized_keys': 
    ensure => present,
    owner => 'app',
    group => 'app',
    mode  => '0600',
    content => template('app/id_rsa.pub'),
    require => File['/home/app/.ssh'],
  }

  file { '/etc/sudoers':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode  => '0440',
    content => template('app/sudoers'),
    require => [User['app'], Group['app']],
  }
}
