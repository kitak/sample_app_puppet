class mysql::config {
  file { '/etc/my.cnf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mysql/my.cnf'),
  }
}
