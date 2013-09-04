#!/bin/bash

if [-d /tmp/sample_app_puppet]; then
  sudo yum -y install git
  sudo gem install puppet --no-ri --no-rdoc
  cd /tmp/sample_app_puppet
  git pull origin master
else
  cd /tmp
  git clone https://github.com/kitak/sample_app_puppet.git
  cd ./sample_app_puppet
fi
sudo puppet apply --modulepath=modules:roles --environment=local manifests/db.pp --debug
