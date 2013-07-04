class memcached () {
  include memcached::install
  include memcached::service

     Class['memcached::install']
  -> Class['memcached::service']
}
