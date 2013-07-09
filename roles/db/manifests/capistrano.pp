class db::capistrano { 
  $user = "kitak"
  $group = "paperboy"

  file { "/home/${user}/.ssh":
    ensure => directory,
    owner => $user,
    group => $group,
    mode => '0700',
  }

  file { "/home/${user}/.ssh/authorized_keys": 
    ensure => present,
    owner => $user,
    group => $group,
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
  }
}
