class rbenv::setup {
  $ruby_version = "2.0.0-p195"

  Exec {
    path =>  ['/usr/local/rbenv/shims', '/usr/local/rbenv/bin', '/bin', '/usr/bin'],
  }

  exec { "use ruby${ruby_version}":
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    command     => "echo '${ruby_version}' > /usr/local/rbenv/version",
    unless      => "test `cat /usr/local/rbenv/version` == '${ruby_version}'",
  } 
  
  exec { 'bundler':
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    command     => "sh -c 'source /etc/profile.d/rbenv.sh; gem install bundler; rbenv rehash'",
    unless      => "test -x /usr/local/rbenv/shims/bundle",
    require     => Exec["use ruby${ruby_version}"],
  }
}
