class db {
  include ::mysql 
  include common::intall
  include db::setup
  include db::mysql::config
  include db::capistrano

     Class[db::mysql::config]
  ~> Class[::mysql::service]
  -> Class[db::setup]
}
