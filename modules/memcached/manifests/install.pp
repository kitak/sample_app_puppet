class memcached::install () {
  package { 'memcached':
    ensure => installed,
  }
}
