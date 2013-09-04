class yumrepo::repos {
  yumrepo {
    'epel':
      descr      => 'epel',
      mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
      enabled    => 1,
      gpgcheck   => 0;
  }
}
