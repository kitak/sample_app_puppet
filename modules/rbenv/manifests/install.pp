class rbenv::install {
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
}
