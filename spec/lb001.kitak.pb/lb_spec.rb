require 'spec_helper'

describe "ssh" do
  describe port(22) do
    it { should be_listening.with("tcp") }
  end
end

proxy_host = "app.kitak.pb"
describe host(proxy_host) do
  it { should be_reachable.with(port: 80, proto: "tcp") }
end
