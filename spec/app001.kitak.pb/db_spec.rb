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

