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
  unless      => "test `cat /usr/local/rbenv/version` == '2.0.0-p195'",
  require     => Exec["ruby2.0.0-p195"],
} 

exec { 'bundler':
  environment => ['RBENV_ROOT="/usr/local/rbenv"'],
  path        => ['/usr/local/rbenv/shims', '/usr/local/rbenv/bin', '/bin', '/usr/bin'],
  command     => "sh -c 'source /etc/profile.d/rbenv.sh; gem install bundler; rbenv rehash'",
  unless      => "test -x /usr/local/rbenv/shims/bundle",
  require     => Exec["use ruby2.0.0-p195"],
}

$mysql_root_password = "L0BrEpuva"
exec { "set mysql root password":
  path    => ["/bin", "/usr/bin"],
  command => "mysqladmin -uroot password $mysql_root_password",
  unless  => "mysqladmin -uroot -p$mysql_root_password status",
  require => Service["mysqld"],
}

$mysql_app_password = "AV8jsDIml"
exec { "create mysql user for app":
  path    => ["/bin", "/usr/bin"],
  command => "mysql -uroot -p$mysql_root_password -e \"GRANT ALL PRIVILEGES ON sample_app_production.* TO app001@localhost identified by '$mysql_app_password'; FLUSH PRIVILEGES;\"",
  unless  => "mysqladmin -uapp001 -p$mysql_app_password status",
  require => Exec['set mysql root password'],
}

exec { "create production database":
  path    => ["/bin", "/usr/bin"],
  command => "mysql -uapp001 -p$mysql_app_password -e \"CREATE DATABASE sample_app_production DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;\"",
  onlyif  => "test `mysql -u app001 -p$mysql_app_password -e \"SHOW DATABASES LIKE 'sample_app_production'\\G\" | wc -l` -eq 0",
  require => Exec['create mysql user for app'],
}
