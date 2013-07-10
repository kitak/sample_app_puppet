class proxy {
  include ::nginx
  include ::rbenv
  include app::user_group
  include app::rails_app
  include proxy::nginx::config

  $etc_packages = [
    'wget',
    'zsh',
    'nc',
  ]
  package { $etc_packages:
    ensure => installed,
  }

     Class['app::user_group']
  -> Class['app::rails_app']
  -> Class['::rbenv::install']

     Class['proxy::nginx::config']
  ~> Class['::nginx::service']
}
