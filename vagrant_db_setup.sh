#!/bin/bash

sudo yum -y install git
sudo gem install puppet --no-ri --no-rdoc
cd /tmp
git clone https://github.com/kitak/sample_app_puppet.git
cd ./sample_app_puppet
sudo puppet apply --modulepath=modules:roles --environment=local manifests/db.pp --debug
