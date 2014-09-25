require ::File.expand_path('../../spec_helper', __FILE__)

describe file('/etc/php-fpm.d/www.conf') do
  it { should be_file }
  case $ohaidata[:ec2][:instance_type]
  when 't1.micro'
    it { should contain /^\s*pm.max_children\s*=\s5/ }
  when 'm1.large'
    it { should contain /^\s*pm.max_children\s*=\s20/ }
  end
end

describe 'PHP config parameters' do
  context  php_config('default_mimetype') do
    its(:value) { should eq 'text/html' }
  end

  context php_config('upload_max_filesize') do
    its(:value) { should eq '4M' }
  end

  context php_config('post_max_size') do
    its(:value) { should eq '8M' }
  end
end
