require 'spec_helper'
require 'app_params'

describe "ssh" do
  describe port(22) do
    it { should be_listening.with("tcp") }
  end
end

describe user(APP_USER) do
  it { should exist }
  it { should have_uid 1000 }
  it { should belong_to_group APP_GROUP }
  it { should have_home_directory "/home/#{APP_USER}" }
  it { should have_login_shell '/bin/bash' }
  it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3o9tKHgAOoJn5K2Bo+4DHsxl5wjInMivYH9rLIc+eW6vIkoCZuW4uzvQqcT1KljSgzTCzcqexFdKh4XlKx+B9z+pkw4Bpq60y5rUZqFmkULE+cDObmnpjWht+GXnyNaoPE+/ORf+JFoJLpQoRIH01+J10B+fGKnmMqBEVv2bzN780F7mloNGPoj2EF214EPRuwABA6aiMQTmrL4HFB0QF0Ey9Uyz0Fsb752xk/t8NNL4p71HgQHOnTGJZkd2PkVIXuQA4OgpPMoji5gXeMxrtO42ENhTOcILIFH0OO2OW4nvl4JVHSI2Hq2IpDB9+da6EBLoR3yjhZM6uSq0DETYr k304@k304-mbp.local' }
end

describe group(APP_GROUP) do
  it { should exist }
  it { should have_gid 1000 }
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
    it { should contain "include mime.types;" }
    it { should contain(<<-EOS) }
    upstream backend {
      server app001.kitak.pb:8080;
      server app002.kitak.pb:8080;
    }
    EOS
    it { should contain "proxy_pass http://backend" }
  end
end

describe "ruby" do
  describe command('cat /usr/local/rbenv/version') do
    it { should return_stdout "2.0.0-p195" }
  end

  describe package('bundler') do
    let(:path) { '/usr/local/rbenv/shims' }
    it { should be_installed.by('gem') }
  end
end

describe "sample_app" do
  describe host("app001.kitak.pb") do
    it { should be_reachable.with(port: 8080, proto: "tcp") }
  end

  describe host("app002.kitak.pb") do
    it { should be_reachable.with(port: 8080, proto: "tcp") }
  end
end

describe "linux kernel parameters" do
  context linux_kernel_parameter('net.ipv4.conf.all.arp_ignore') do
    its(:value) { should eq 1 }
  end

  context linux_kernel_parameter('net.ipv4.conf.eth0.arp_ignore') do
    its(:value) { should eq 1 }
  end

  context linux_kernel_parameter('net.ipv4.conf.all.arp_announce') do
    its(:value) { should eq 2 }
  end

  context linux_kernel_parameter('net.ipv4.conf.eth0.arp_announce') do
    its(:value) { should eq 2 }
  end
end
