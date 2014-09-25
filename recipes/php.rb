# php54 install

node[:php][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure php

%w{ php.ini php-fpm.conf php.d/apc.ini php.d/memcache.ini php-fpm.d/www.conf }.each do | file_name |
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
  action node[:php][:service_action]
end
