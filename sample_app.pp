$manifest_dir = "/home/kitak/sample_app_spec_puppet"

$nginx_packages = [
  'nginx',
]

$mysql_packages = [
  'mysql-server',
  'mysql-devel',
]

$ruby_build_packages = [
  'gcc',
  'gcc-c++',
  'make',
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

$etc_packages = [
  'wget',
  'zsh',
]

package { $nginx_packages:
  ensure => installed,
}

package { $mysql_packages:
  ensure => installed,
}

package { $ruby_build_packages:
  ensure => installed,
}

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
  require => [User['app'], Group['app']],
}

exec { 'ruby2.0.0-p195':
  user        => 'app',
  environment => ['RBENV_ROOT="/usr/local/rbenv"'],
  path        => ['/bin', '/usr/bin', '/usr/local/ruby-build/bin'],
  command     => "ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195",
  require     => [Exec['rbenv'], Packages[$ruby_build_packages]],
  unless      => "test -d /usr/local/rbenv/versions/2.0.0-p195",
  timeout     => 100000000,
}

exec { 'use ruby2.0.0-p195':
  user        => 'app',
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
  command => "mysql -uroot -p$mysql_root_password -e \"GRANT ALL PRIVILEGES ON sample_app_production.* TO app@localhost identified by '$mysql_app_password'; FLUSH PRIVILEGES;\"",
  unless  => "mysqladmin -uapp -p$mysql_app_password status",
  require => Exec['set mysql root password'],
}

exec { "create production database":
  path    => ["/bin", "/usr/bin"],
  command => "mysql -uapp -p$mysql_app_password -e \"CREATE DATABASE sample_app_production DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;\"",
  onlyif  => "test `mysql -uapp -p$mysql_app_password -e \"SHOW DATABASES LIKE 'sample_app_production'\\G\" | wc -l` -eq 0",
  require => Exec['create mysql user for app'],
}
