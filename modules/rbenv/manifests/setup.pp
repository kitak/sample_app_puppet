class rbenv::setup {
  Exec {
    path =>  ['/usr/local/rbenv/shims', '/usr/local/rbenv/bin', '/bin', '/usr/bin'],
  }

  exec { "use ruby${rbenv::ruby_version}":
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    command     => "echo '${rbenv::ruby_version}' > /usr/local/rbenv/version",
    unless      => "test `cat /usr/local/rbenv/version` == '${rbenv::ruby_version}'",
  }

  exec { 'bundler':
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    command     => "sh -c 'source /etc/profile.d/rbenv.sh; gem install bundler; rbenv rehash'",
    unless      => "test -x /usr/local/rbenv/shims/bundle",
    require     => Exec["use ruby${rbenv::ruby_version}"],
  }
}
