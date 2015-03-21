# php54 install

node[:php][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure php

%w{ php.ini php-fpm.conf php.d/memcache.ini php-fpm.d/www.conf }.each do | file_name |
  template "/etc/" + file_name do
    variables node[:php][:config]
    source "php/" + file_name + ".erb"
    notifies :reload, 'service[php-fpm]'
  end
end

%w{ /var/tmp/php /var/tmp/php/session /var/log/php-fpm }.each do | dir_name |
  directory dir_name do
    owner node[:php][:config][:user]
    group node[:php][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

service "php-fpm" do
  action [:stop, :disable]
end

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

service 'hhvm' do
  action node[:hhvm][:service_action]
end
