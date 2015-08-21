# php install

node.override[:php][:packages] = node[:php][:packages] - %w{ php-opcache }

include_recipe 'amimoto::php'

# hhvm install

%w{ hop5.repo opsrock-hhvm.repo }.each do | file_name |
  template "/etc/yum.repos.d/" + file_name do
    source "yum/" + file_name + ".erb"
  end
end

%w[ glog tbb ].map do |pkg|
  yum_package pkg do
    action [:install, :upgrade]
    options '-y --nogpgcheck'
  end
end

yum_package 'libmemcached'
yum_package 'hhvm' do
  action [:install]
  options '-y --nogpgcheck'
end

# hhvm configure

template "/etc/hhvm/server.ini" do
  variables node[:hhvm][:config]
  source "hhvm/server.ini.erb"
  notifies :restart, 'service[hhvm]'
end

template "/etc/hhvm/php.ini" do
  variables node[:php][:config]
  source "php/php.ini.erb"
  notifies :restart, 'service[hhvm]'
end

template "/etc/logrotate.d/hhvm" do
  variables node[:hhvm][:config]
  source "logrotat.d/hhvm.erb"
end

# hhvm start

if node[:hhvm][:enabled]
  service "php-fpm" do
    action [:stop, :disable]
  end
end

service 'hhvm' do
  action node[:hhvm][:service_action]
end
