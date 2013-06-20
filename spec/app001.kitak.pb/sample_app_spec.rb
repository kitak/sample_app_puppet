require 'spec_helper'

APP_USER = "app"
APP_GROUP = "app"
APP_PATH = "/var/www/rails/sample_app"

describe "ssh" do
  describe port(22) do
    it { should be_listening }
  end
end

describe user(APP_USER) do
  it { should exist }
  it { should have_uid 1000 }
  it { should have_home_directory "/home/#{APP_USER}" }
end

describe group(APP_GROUP) do
  it { should exist }
  it { should have_gid 1000 }
end

describe "rails app" do
  describe file(APP_PATH) do
    it { should be_directory }
  end

  describe file(APP_PATH) do
    it { should be_owned_by APP_USER }
  end

  describe file("#{APP_PATH}/config/database.yml") do
    it { should contain('mysql2').after(/^production:/)}
  end

  describe file("#{APP_PATH}/Gemfile") do
    it { should contain('mysql2').from(/^group :production/).to(/^end/) }
    it { should contain('unicorn') }
    it { should contain('therubyracer') }
  end
end

describe "nginx" do
  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
    it { should contain "include mime.types;" }
    it { should contain(<<-EOS) }
    upstream backend {
      server unix:#{APP_PATH}/tmp/sockets/nginx.sock;
    }
    EOS
    it { should contain "proxy_pass http://backend" }
  end
end

describe "unicorn" do
  describe file("#{APP_PATH}/tmp/sockets/nginx.sock") do
    it { should be_socket }
  end

  describe file("#{APP_PATH}/config/unicorn.rb") do
    it { should be_file }
  end

  describe command('ps aux | grep unicorn') do
    it { should return_stdout /^#{APP_USER}.+unicorn master/ }

    4.times do |i|
      it { should return_stdout /^#{APP_USER}.+unicorn worker\[#{i}\]/ }
    end
  end
end

describe "mysql" do
  describe package('mysql-server') do
    it { should be_installed }
  end

  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening }
  end
end

