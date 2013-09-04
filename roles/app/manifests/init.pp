class app {
  if ($environment == 'local') {
    include ::yumrepo
    include ::iptables
  }
  include ::rbenv
  include ::monit
  include common::install
  include app::user_group
  include app::sample_app
  include app::monit::config

  if ($environment == 'local') {
       Class['::yumrepo::repos']
    -> Class['app::user_group']
    -> Class['app::sample_app']
    -> Class['::rbenv::install']
  } else {
       Class['app::user_group']
    -> Class['app::sample_app']
    -> Class['::rbenv::install']
  }

     Class['app::monit::config']
  ~> Class['::monit::service']
}
