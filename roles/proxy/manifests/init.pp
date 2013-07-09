class proxy {
  include ::nginx
  include proxy::nginx::config

  $etc_packages = [
    'wget',
    'zsh',
    'nc',
  ]
  package { $etc_packages:
    ensure => installed,
  }

     Class['app::nginx::config']
  ~> Class['::nginx::service']
}
