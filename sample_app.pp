$manifest_dir = "/home/kitak/sample_app_spec_puppet"
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
  ensure     => present,
  comment    => 'app001',
  home       => '/home/app001',
  managehome => true,
  shell      => '/bin/bash',
  uid        => 1000,
  gid        => 'app001',
}

group { 'app001':
  ensure => present,
  gid    => 1000,
}

file { '/etc/nginx/nginx.conf':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('nginx.conf'),
  notify  => Service['nginx'],
}

service { 'nginx':
  enable     => true,
  ensure     => running,
  hasrestart => true,
  require    => Package['nginx'],
}

service { 'mysqld':
  enable     => true,
  ensure     => running,
  hasrestart => true,
  require    => Package['mysql-server'],
}

#exec { 'mysql_secure_installation':
#   command => '/usr/bin/mysql -uroot -e "DELETE FROM mysql.user WHERE User=\'\'; DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;" mysql',
#        require => Service['mysqld'],
#}

exec { 'rbenv':
  cwd     => '/usr/local',
  path    => ['/bin', '/usr/bin'],
  command => "sh ${manifest_dir}/install_rbenv_system-wide.sh",
  creates => '/usr/local/rbenv',
  require => [User['app001'], Group['app001']],
}

exec { 'ruby2.0.0-p195':
  user        => 'app001',
  environment => ['RBENV_ROOT="/usr/local/rbenv"'],
  path        => ['/bin', '/usr/bin', '/usr/local/ruby-build/bin'],
  command     => "ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195",
  require     => [Exec['rbenv'], User['app001'], Group['app001']],
  unless      => "test -d /usr/local/rbenv/versions/2.0.0-p195",
  timeout     => 100000000,
}

exec { 'use ruby2.0.0-p195':
  user        => 'app001',
  environment => ['RBENV_ROOT="/usr/local/rbenv"'],
  path        => ['/bin', '/usr/bin', '/usr/local/rbenv/bin'],
  command     => "echo '2.0.0-p195' > /usr/local/rbenv/version",
  require     => Exec["ruby2.0.0-p195"],
} 

exec { 'bundler':
  environment => ['RBENV_ROOT="/usr/local/rbenv"'],
  path        => ['/usr/local/rbenv/shims', '/usr/local/rbenv/bin', '/bin', '/usr/bin'],
  command     => "sh -c 'source /etc/profile.d/rbenv.sh; gem install bundler; rbenv rehash'",
  require     => Exec["use ruby2.0.0-p195"],
}
