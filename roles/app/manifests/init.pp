class app {
  include ::nginx
  include ::rbenv
  include ::monit
  include ::memcached
  include app::user_group
  include app::rails_app
  include app::nginx::config

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

     Class['app::nginx::conf']
  ~> Class['::nginx::service']
}
