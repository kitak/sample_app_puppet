class db {
  include ::mysql 
  include db::setup
  include db::mysql::config

     Class[db::mysql::config]
  ~> Class[::mysql::service]
  -> Class[db::setup]
}
