# httpd install

node[:httpd][:packages].each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

# configure nginx

template "/etc/httpd/conf/httpd.conf" do
  variables node[:httpd][:config]
  source "httpd/conf/httpd.conf.erb"
  if node[:httpd][:service_action].include?(:start)
    notifies :restart, 'service[httpd]'
  end
end

%W{ /var/log/httpd }.each do | dir_name |
  directory dir_name do
    owner node[:httpd][:config][:user]
    group node[:httpd][:config][:group]
    mode 00700
    recursive true
    action :create
  end
end

%W{ /opt/local/amimoto /opt/local/amimoto/wp-admin /var/www/vhosts/#{node[:ec2][:instance_id]} }.each do | dir_name |
  directory dir_name do
    owner node[:httpd][:config][:user]
    group node[:httpd][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

service "httpd" do
  action node[:httpd][:service_action]
end
