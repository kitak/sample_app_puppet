class yumrepo::repos {
  yumrepo {
    'epel':
      descr      => 'epel',
      mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5    &arch=$basearch',
      enabled    => 1,
      gpgcheck   => 0;
  }
}
