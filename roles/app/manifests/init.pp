class app {
  include ::rbenv
  include ::monit
  include common::install
  include app::user_group
  include app::sample_app
  include app::monit::config

     Class['app::user_group']
  -> Class['app::sample_app']
  -> Class['::rbenv::install']

     Class['app::monit::config']
  ~> Class['::monit::service']
}
