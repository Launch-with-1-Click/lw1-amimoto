# configure httpd

## compiled with apxs 2.2 on amazon linux
cookbook_file "/usr/lib64/httpd/modules/mod_remoteip.so" do
  source "httpd22/mod_remoteip.so"
  owner "root"
  group "root"
  mode  "0755"
end


template "/etc/httpd/conf/httpd.conf" do
  variables node[:httpd][:config]
  source "httpd/conf/httpd.conf.erb"
  if node[:httpd][:service_action].include?(:start)
    notifies :restart, 'service[httpd]'
  end
end

template "/etc/httpd/conf.d/install_check.conf" do
  variables node[:httpd][:config]
  source "httpd/conf.d/install_check.conf.erb"
  if node[:httpd][:service_action].include?(:start)
    notifies :restart, 'service[httpd]'
  end
end

template "/etc/httpd/conf.d/mod_remoteip.conf" do
  variables node[:httpd][:config]
  source "httpd/conf.d/mod_remoteip.conf.erb"
  if node[:httpd][:service_action].include?(:start)
    notifies :restart, 'service[httpd]'
  end
end

template "/etc/httpd/conf.d/wordpress.conf" do
  variables node[:httpd][:config]
  source "httpd/conf.d/wordpress.conf.erb"
  if node[:httpd][:service_action].include?(:start)
    notifies :restart, 'service[httpd]'
  end
end

service "httpd" do
  action node[:httpd][:service_action]
end
