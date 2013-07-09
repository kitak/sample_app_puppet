require 'spec_helper'

describe "ssh" do
  describe port(22) do
    it { should be_listening.with("tcp") }
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
    it { should be_listening.with("tcp") }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
  end

  describe file('/etc/nginx/conf.d/proxy.conf') do
    it { should be_file }
    it { should contain(<<-EOS) }
    upstream backend {
      server app001.kitak.pb;
      server app002.kitak.pb;
    }
    EOS
    it { should contain "proxy_pass http://backend" }
  end
end
