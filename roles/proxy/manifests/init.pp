class proxy {
  include ::nginx
  include ::rbenv
  include app::user_group
  include proxy::nginx::config

  file { '/var/www':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0755',
  }

  file { '/var/www/rails':
    ensure => directory,
    owner => 'app',
    group => 'app',
    mode => '0755', 
    require => File['/var/www'],
  }

  $etc_packages = [
    'wget',
    'zsh',
    'nc',
  ]
  package { $etc_packages:
    ensure => installed,
  }

     Class['app::user_group']
  -> Class['::rbenv::install']

     Class['proxy::nginx::config']
  ~> Class['::nginx::service']
}
