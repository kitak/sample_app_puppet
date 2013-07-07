class mysql::config {
  $ip_address = "192.168.0.101"

  file { '/etc/my.cnf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mysql/my.cnf'),
  }
}
