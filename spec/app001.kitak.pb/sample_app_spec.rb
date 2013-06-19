require 'spec_helper'

describe "ssh" do
  describe port(22) do
    it { should be_listening }
  end
end

describe user('app001') do
  it { should exist }
  it { should have_uid 1000 }
  it { should have_home_directory '/home/app001' }
end

describe group('app001') do
  it { should exist }
  it { should have_gid 1000 }
end

describe "rails app" do
  describe file('/var/www/rails/sample_app') do
    it { should be_owned_by 'app001' }
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
    it { should contain "server_name app001.kitak.pb;" }
    it { should contain "include mime.types;" }
  end
end

describe "unicorn" do
  describe file('/var/www/rails/sample_app/tmp/sockets/nginx.sock') do
    it { should be_socket }
  end

  describe command('ps aux | grep unicorn') do
    it { should return_stdout /unicorn master/ }

    4.times do |i|
      it { should return_stdout /unicorn worker\[#{i}\]/ }
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

