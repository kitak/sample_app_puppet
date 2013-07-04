$etc_packages = [
  'wget',
  'zsh',
]

package { $etc_packages:
  ensure => installed,
}

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

exec { 'create rails-web-app dir':
  path    => ['/bin', '/usr/bin'],
  command => "mkdir -p /var/www/rails",
  creates => '/var/www/rails',
}

file { '/etc/init.d/unicorn':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => template('unicorn_ini.sh'),
}

file { '/var/www/rails':
  ensure => directory,
  owner => 'app',
  group => 'app',
  mode => '0755'
}

file { '/home/app/.ssh':
  ensure => directory,
  owner => 'app',
  group => 'app',
  mode => '0700'
}

file { '/home/app/.ssh/authorized_keys': 
  ensure => present,
  owner => 'app',
  group => 'app',
  mode  => '0600',
  content => template('id_rsa.pub'),
}

file { '/etc/sudoers':
  ensure => present,
  owner => 'root',
  group => 'root',
  mode  => '0440',
  content => template('sudoers'),
}

include nginx
include mysql
include rbenv
include monit
include memcached
