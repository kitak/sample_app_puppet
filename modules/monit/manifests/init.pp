class monit () {
  include monit::install
  include monit::service

     Class['monit::install']
  -> Class['monit::config']
  ~> Class['monit::service']
}
