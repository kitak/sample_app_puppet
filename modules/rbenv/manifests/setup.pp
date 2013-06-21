class rbenv::setup {
  exec { 'use ruby2.0.0-p195':
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    path        => ['/bin', '/usr/bin', '/usr/local/rbenv/bin'],
    command     => "echo '2.0.0-p195' > /usr/local/rbenv/version",
    unless      => "test `cat /usr/local/rbenv/version` == '2.0.0-p195'",
  } 
  
  exec { 'bundler':
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    path        => ['/usr/local/rbenv/shims', '/usr/local/rbenv/bin', '/bin', '/usr/bin'],
    command     => "sh -c 'source /etc/profile.d/rbenv.sh; gem install bundler; rbenv rehash'",
    unless      => "test -x /usr/local/rbenv/shims/bundle",
    require     => Exec["use ruby2.0.0-p195"],
  }
}
