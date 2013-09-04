class db {
  if ($enviroment == 'local') {
    include ::yumrepo
    include ::iptables
  }
  include ::mysql
  include common::install
  include db::setup
  include db::mysql::config
  include db::capistrano

  if ($environment == 'local') {
       Class['::yumrepo::repos']
    -> Class['::mysql::install']
  }

     Class['db::mysql::config']
  ~> Class['::mysql::service']
  -> Class['db::setup']
}
