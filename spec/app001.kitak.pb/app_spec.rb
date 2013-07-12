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

describe "rails app" do
  describe file(APP_PATH) do
    it { should be_directory }
    it { should be_owned_by APP_USER }
    it { should be_grouped_into APP_GROUP }
  end

  describe file(APP_PATH) do
    it { should be_owned_by APP_USER }
  end

  describe file("#{APP_PATH}/config/database.yml") do
    it { should contain('mysql2').after(/^production:/)}
    it { should contain('db001.kitak.pblan').after(/^production:/)}
  end

  describe file("#{APP_PATH}/Gemfile") do
    it { should contain('mysql2').from(/^group :production/).to(/^end/) }
    it { should contain('unicorn') }
    it { should contain('therubyracer') }
  end
end

describe "unicorn" do
  describe file("#{APP_PATH}/run/unicorn.sock") do
    it { should be_socket }
  end

  describe file("#{APP_PATH}/config/unicorn.rb") do
    it { should be_file }
  end

  describe service('unicorn') do
    it { should be_monitored_by('monit') }
  end

  describe command('ps aux | grep unicorn') do
    it { should return_stdout /^#{APP_USER}.+unicorn master/ }

    4.times do |i|
      it { should return_stdout /^#{APP_USER}.+unicorn worker\[#{i}\]/ }
    end
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

describe "monit" do
  describe package('monit') do
    it { should be_installed }
  end

  describe service('monit') do
    it { should be_running.under('upstart') }
  end

  describe file('/etc/monit.conf') do
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by 'root' }
  end

  describe file('/etc/monit.d/unicorn') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end
end

describe "memcached" do
  describe package('memcached') do
    it { should be_installed }
  end

  describe service('memcached') do
    it { should be_running }
  end

  describe port(11211) do
    it { should be_listening.with("tcp") }
  end
end

db_host = "db001.kitak.pblan"
describe host(db_host) do
  it { should be_reachable.with(port: 3306, proto: "tcp") }
end
