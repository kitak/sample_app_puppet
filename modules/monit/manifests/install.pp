class monit::install {
  package { "monit":
    ensure => installed,
  }
}
