class rbenv::build {
  exec { "ruby${rbenv::ruby_version}":
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    path        => ['/bin', '/usr/bin', '/usr/local/ruby-build/bin'],
    command     => "ruby-build ${rbenv::ruby_version} /usr/local/rbenv/versions/${rbenv::ruby_version}",
    unless      => "test -d /usr/local/rbenv/versions/${rbenv::ruby_version}",
    timeout     => 0,
  }
}
