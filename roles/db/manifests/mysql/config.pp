class db::mysql::config { 
  file { '/etc/my.cnf':
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('db/mysql/my.cnf'),
  }

  file { '/etc/mysql.d':
    ensure =>  directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { '/etc/mysql.d/mysqld.cnf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('db/mysql/mysqld.cnf'),
    require => File['/etc/mysql.d'],
  }

  file { '/etc/mysql.d/mysqld_safe.cnf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('db/mysql/mysqld.cnf'),
    require => File['/etc/mysql.d'],
  }
}
