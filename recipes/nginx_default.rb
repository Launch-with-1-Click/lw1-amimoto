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

service "nginx" do
  action node[:nginx][:service_action]
end
