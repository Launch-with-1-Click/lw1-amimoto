# nginx install

service "httpd" do
  action [:stop, :disable]
end
node[:nginx][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure nginx

template "/etc/nginx/nginx.conf" do
  variables node[:nginx][:config]
  source "nginx/nginx.conf.erb"
  notifies :reload, 'service[nginx]'
end

%w{ drop expires mobile-detect phpmyadmin php-fpm wp-multisite-subdir wp-singlesite }.each do | file_name |
  template "/etc/nginx/" + file_name do
    variables node[:nginx][:config]
    source "nginx/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%W{ /var/cache/nginx /var/log/nginx /var/lib/nginx /var/tmp/nginx /var/www/vhosts/#{node[:ec2][:instance_id]} }.each do | dir_name |
  directory dir_name do
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

service "nginx" do
  action node[:nginx][:service_action]
end
