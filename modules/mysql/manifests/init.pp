class mysql () {
  include mysql::install
  include mysql::service

     Class['mysql::install']
  ~> Class['mysql::service']
}
