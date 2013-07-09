class db::capistrano { 
  $user = "kitak"

  file { "/home/${user}/.ssh":
    ensure => directory,
    owner => $user,
    group => $user,
    mode => '0700',
    require => [User[$user], Group[$user]],
  }

  file { "/home/${user}/.ssh/authorized_keys": 
    ensure => present,
    owner => $user,
    group => $user,
    mode  => '0600',
    content => template('common/id_rsa.pub'),
    require => File["/home/${user}/.ssh"],
  }

  file { '/etc/sudoers':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode  => '0440',
    content => template('db/sudoers'),
    require => [User[$user], Group[$user]],
  }
}
