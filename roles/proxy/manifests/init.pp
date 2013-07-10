class proxy {
  include ::nginx
  include ::rbenv
  include common::install
  include app::user_group
  include proxy::sample_app 
  include proxy::nginx::config

     Class['app::user_group']
  -> Class['::rbenv::install']

     Class['proxy::nginx::config']
  ~> Class['::nginx::service']
}
