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

include nginx
include mysql
include rbenv
include monit
