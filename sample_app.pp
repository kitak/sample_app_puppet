package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  enable => true,
  ensure => running,
  hasrestart => true,
}

package { 'mysql-server':
  ensure => installed,
}
