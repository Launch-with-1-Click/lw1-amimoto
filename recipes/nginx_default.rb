# configure nginx.conf
%w{ default.conf default.backend.conf }.each do | file_name |
  template "/etc/nginx/conf.d/" + file_name do
    variables(
      :server_name => node[:ec2][:instance_id],
      :phpmyadmin_enable => node[:nginx][:config][:phpmyadmin_enable]
    )
    source "nginx/conf.d/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

directory "/opt/local/amimoto/wp-admin" do
  owner node[:php][:config][:user]
  group node[:php][:config][:group]
  mode 00755
  recursive true
  action :create
end

template "/opt/local/amimoto/wp-admin/install.php" do
  variables(
    :instance_id => node[:ec2][:instance_id]
  )
  source "install.php.erb"
end

service "nginx" do
  action node[:nginx][:service_action]
end
