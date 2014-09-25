require ::File.expand_path('../../spec_helper', __FILE__)

describe service('iptables') do
  it { should_not be_enabled }
  it { should_not be_running }
end
