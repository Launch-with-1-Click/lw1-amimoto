require ::File.expand_path('../../spec_helper', __FILE__)

%w{ memcached zip unzip wget iptables git }.each do | pkg |
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/etc/my.cnf') do
  it { should be_file }
  case $ohaidata[:ec2][:instance_type]
  when 't1.micro'
    it { should contain /^\s*innodb_buffer_pool_size\s*=\s*64M/ }
  when 'm1.large'
    it { should contain /^\s*innodb_buffer_pool_size\s*=\s*256M/ }
  end
end
