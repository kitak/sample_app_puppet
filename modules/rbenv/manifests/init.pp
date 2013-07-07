class rbenv () {
  $ruby_version = "2.0.0-p195"

  include rbenv::install
  include rbenv::build
  include rbenv::setup
  
     Class['rbenv::install']
  -> Class['rbenv::build']
  -> Class['rbenv::setup']
}
