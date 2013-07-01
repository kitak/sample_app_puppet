class rbenv::build {
  $ruby_version = "2.0.0-p247"
  exec { "ruby${ruby_version}":
    user        => 'app',
    environment => ['RBENV_ROOT="/usr/local/rbenv"'],
    path        => ['/bin', '/usr/bin', '/usr/local/ruby-build/bin'],
    command     => "ruby-build ${ruby_version} /usr/local/rbenv/versions/${ruby_version}",
    unless      => "test -d /usr/local/rbenv/versions/${ruby_version}",
    timeout     => 0,
  }
}
