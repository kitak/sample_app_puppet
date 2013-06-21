class rbenv::build {
  exec { 'ruby2.0.0-p195':
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    path        => ['/bin', '/usr/bin', '/usr/local/ruby-build/bin'],
    command     => "ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195",
    unless      => "test -d /usr/local/rbenv/versions/2.0.0-p195",
    timeout     => 0,
  }
}
