# mod_php7 install
execute '/usr/bin/yum clean all'

yum_package 'libwebp' do
  action [:install, :upgrade]
  options '--enablerepo=epel --disablerepo=amzn-main'
end

node[:mod_php7][:packages].each do | pkg |
  yum_package pkg do
    options "--enablerepo=epel"
    action [:install, :upgrade]
  end
end

file '/etc/httpd/conf.d/php.conf' do
  action :delete
end

# configure php

%w{ php.ini }.each do | file_name |
  template "/etc/" + file_name do
    variables node[:php][:config]
    source "php/" + file_name + ".erb"
    notifies :reload, 'service[httpd]'
  end
end

execute 'backup default php70.ini' do
  command "cp /etc/opt/remi/php70/php.ini /etc/opt/remi/php70/php.ini.rpmdefault"
  creates "/etc/opt/remi/php70/php.ini.rpmdefault"
end

link '/etc/opt/remi/php70/php.ini' do
  to '/etc/php.ini'
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

# php-fpm stop, disable

service "httpd" do
  action node[:httpd][:service_action]
end

service "php-fpm" do
  action node[:phpfpm][:service_action]
end
