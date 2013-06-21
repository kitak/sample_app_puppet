class mysql () {
  include mysql::install
  include mysql::service
  include mysql::setup

     Class['mysql::install']
  -> Class['mysql::service']
  -> Class['mysql::setup']
}
