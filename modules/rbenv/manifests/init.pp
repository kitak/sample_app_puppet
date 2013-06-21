class rbenv () {
  $manifest_dir = "/home/kitak/sample_app_puppet"

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

  package { $ruby_build_packages:
    ensure => installed,
  }

  exec { 'rbenv':
    cwd     => '/usr/local',
    path    => ['/bin', '/usr/bin'],
    command => "sh ${manifest_dir}/modules/rbenv/scripts/install_system-wide.sh",
    creates => '/usr/local/rbenv',
    require => [User['app'], Group['app']],
  }
  
  exec { 'ruby2.0.0-p195':
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    path        => ['/bin', '/usr/bin', '/usr/local/ruby-build/bin'],
    command     => "ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195",
    require     => [Exec['rbenv'], Package[$ruby_build_packages]],
    unless      => "test -d /usr/local/rbenv/versions/2.0.0-p195",
    timeout     => 0,
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
}
