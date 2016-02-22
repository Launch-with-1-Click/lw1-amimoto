# nginx install

node[:nginx][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure nginx

template "/etc/nginx/nginx.conf" do
  variables node[:nginx][:config]
  source "nginx/nginx.conf.erb"
  notifies :restart, 'service[nginx]'
end

%w{ drop expires mobile-detect phpmyadmin php-fpm wp-multisite-subdir wp-singlesite }.each do | file_name |
  template "/etc/nginx/" + file_name do
    variables node[:nginx][:config]
    source "nginx/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%W{ /var/cache/nginx /var/log/nginx /var/lib/nginx /var/tmp/nginx /var/www/vhosts }.each do | dir_name |
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

## For autoscaled amimoto
if File.exists?('/opt/aws/cf_option.json')
  cfn_opts = JSON.parse(File.read('/opt/aws/cf_option.json'))
  link "/var/www/html" do
    to "/var/www/vhosts/#{node[:ec2][:instance_id]}" do
    only_if { cfn_opts['autoscale'] }
  end
end


# amimoto-nginx-mainline
# default => disable
%w{ amimoto-nginx-mainline.repo }.each do | file_name |
  template "/etc/yum.repos.d/" + file_name do
    source "yum/" + file_name + ".erb"
  end
end
