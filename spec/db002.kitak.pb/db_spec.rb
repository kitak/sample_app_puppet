require 'spec_helper'

describe "ssh" do
  describe port(22) do
    it { should be_listening }
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

describe "replication" do
  describe host("db001.kitak.pb") do
    it { should be_reachable.with(port: 3306, proto: "tcp") }
  end
end
