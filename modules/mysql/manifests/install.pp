class mysql::install {
  $mysql_packages = [
    'mysql-server',
    'mysql-devel',
  ]

  package { $mysql_packages:
    ensure => installed,
  }
}
