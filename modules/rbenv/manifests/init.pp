class rbenv () {
  include rbenv::install
  include rbenv::build
  include rbenv::setup
  
     Class['rbenv::install']
  -> Class['rbenv::build']
  -> Class['rbenv::setup']
}
