# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos-6.4-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.define :app do |app|
    app.vm.network :private_network, ip: "192.168.0.100"
    app.vm.network :forwarded_port, guest: 8080, host: 8080
    app.vm.hostname = "app001.kitak.pb"
    app.vm.provision :shell, :path => 'vagrant_app_setup.sh'
  end

  config.vm.define :db do |db|
    db.vm.network :private_network, ip: "192.168.0.101"
    db.vm.hostname = "db001.kitak.pb"
    db.vm.provision :shell, :path => 'vagrant_db_setup.sh'
  end
end
