# configure nginx.conf
%w{ default.conf default.backend.conf }.each do | file_name |
  template "/etc/nginx/conf.d/" + file_name do
    variables(
      :listen => node[:nginx][:config][:listen],
      :listen_backend => node[:nginx][:config][:listen_backend],
      :server_name => node[:ec2][:instance_id],
      :wp_multisite => node[:nginx][:config][:wp_multisite],
      :mobile_detect_enable => node[:nginx][:config][:mobile_detect_enable],
      :phpmyadmin_enable => node[:nginx][:config][:phpmyadmin_enable]
    )
    source "nginx/conf.d/" + file_name + ".erb"
    notifies :restart, 'service[nginx]'
  end
end

%w{ /opt/local/amimoto /opt/local/amimoto/wp-admin /var/www/vhosts/#{node[:ec2][:instance_id]} }.each do | dir_name |
  directory dir_name do
    owner node[:php][:config][:user]
    group node[:php][:config][:group]
    mode 00755
    recursive true
    action :create
  end
end

template "/opt/local/amimoto/wp-admin/install.php" do
  variables(
    :instance_id => node[:ec2][:instance_id]
  )
  source "install.php.erb"
end
