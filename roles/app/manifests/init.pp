class app {
  include ::rbenv
  include ::monit
  include common::install
  include app::user_group
  include app::rails_app
  include app::monit::config

     Class['app::user_group']
  -> Class['app::rails_app']
  -> Class['::rbenv::install']

     Class['app::monit::config']
  ~> Class['::monit::service']
}
