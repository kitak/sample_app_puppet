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

include nginx
include mysql
include rbenv
