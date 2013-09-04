#!/bin/bash

if [ -d /tmp/sample_app_puppet ]; then
  cd /tmp/sample_app_puppet
  git pull origin master
else
  sudo yum -y install git
  sudo gem install puppet --no-ri --no-rdoc
  cd /tmp
  sudo git clone https://github.com/kitak/sample_app_puppet.git
  cd ./sample_app_puppet
  sudo sh -c "echo '192.168.0.101 db001.kitak.pblan' >> /etc/hosts"
fi
sudo puppet apply --modulepath=modules:roles --environment=local manifests/app001.pp --debug
sudo su - app
if [ ! -d /var/www/rails/sample_app ]; then
  cd /var/www/rails
  mkdir sample_app
  cd sample_app
  git clone https://github.com/kitak/sample_app_rails4.git current
  mkdir shared
  cd current
  mkdir run
  mkdir pids
  bundle install --without test development --path vendor/bundle
  bundle exec rake db:migrate RAILS_ENV=production
  bundle exec rake db:populate RAILS_ENV=production
  bundle exec rake assets:precompile RAILS_ENV=production
fi
