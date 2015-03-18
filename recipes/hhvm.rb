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

yum_package 'hhvm' do
  action [:install]
  options '-y --nogpgcheck --skip-broken'
end

template "/etc/hhvm/server.ini" do
  source "hhvm/server.ini.erb"
end

service 'hhvm' do
  action [:enable, :start]
end
