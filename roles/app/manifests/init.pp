class app {
  include ::rbenv
  include ::monit
  include app::user_group
  include app::rails_app
  include app::monit::config

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

     Class['app::monit::config']
  ~> Class['::monit::service']
}
