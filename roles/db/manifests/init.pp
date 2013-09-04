class db {
  if ($environment == 'local') {
    include ::yumrepo
    include ::iptables
  } else {
    include db::capistrano
  }
  include ::mysql
  include common::install
  include db::setup
  include db::mysql::config

  if ($environment == 'local') {
       Class['::yumrepo::repos']
    -> Class['::mysql::install']
  }

     Class['db::mysql::config']
  ~> Class['::mysql::service']
  -> Class['db::setup']
}
