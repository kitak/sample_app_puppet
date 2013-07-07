class db {
  include ::mysql 
  include db::setup

     Class[::mysql::service]
  -> Class[db::setup]
}
