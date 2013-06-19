$packages = [
  'zsh',
  'mysql-server',
  'mysql-devel',
  'nginx',
  'libyaml',
  'libyaml-devel',
  'zlib',
  'zlib-devel',
  'readline',
  'readline-devel',
  'openssl',
  'openssl-devel',
  'libxml2',
  'libxml2-devel',
  'libxslt',
  'libxslt-devel',
]

package { $packages:
  ensure => installed,
}

user { 'app001':
  ensure => present,
  comment => 'app001',
  home => '/home/app001',
  managehome => true,
  shell => '/bin/bash',
  uid => 1000,
  gid => 'app001',
}

group { 'app001':
  ensure => present,
  gid => 1000,
}

service { 'nginx':
  enable => true,
  ensure => running,
  hasrestart => true,
}
