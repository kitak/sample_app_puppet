$packages = [
  'gcc',
  'gcc-c++',
  'make',
  'wget',
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

file { '/etc/nginx/nginx.conf':
  ensure => present,
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => template('nginx.conf'),
  notify => Service['nginx'],
}

service { 'nginx':
  enable => true,
  ensure => running,
  hasrestart => true,
}

service { 'mysqld':
  enable => true,
  ensure => running,
  hasrestart => true,
}

#exec { 'mysql_secure_installation':
#   command => '/usr/bin/mysql -uroot -e "DELETE FROM mysql.user WHERE User=\'\'; DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;" mysql',
#        require => Service['mysqld'],
#}
