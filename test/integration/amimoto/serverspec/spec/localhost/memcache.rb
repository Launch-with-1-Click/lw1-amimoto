require ::File.expand_path('../../spec_helper', __FILE__)


describe service('memcached') do
  case $ohaidata[:ec2][:instance_type]
  when 't1.micro'
    it { should_not be_enabled }
    it { should_not be_running }
  when 'm1.large'
    it { should be_enabled }
    it { should be_running }
  end
end
