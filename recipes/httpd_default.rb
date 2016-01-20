# configure httpd

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

template "/etc/httpd/conf.d/wordpress.conf" do
  variables node[:httpd][:config]
  source "httpd/conf.d/wordpress.conf.erb"
  if node[:httpd][:service_action].include?(:start)
    notifies :restart, 'service[httpd]'
  end
end

