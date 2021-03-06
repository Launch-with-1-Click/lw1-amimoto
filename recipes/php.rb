# create www Group
group node[:php][:config][:group] do
  members ['ec2-user',node[:php][:config][:user]]
  action :create
end

# php install
yum_package 'libwebp' do
  action [:install, :upgrade]
  options "--enablerepo=epel --disablerepo=amzn-main"
  notifies :run, 'bash[update-motd]', :delayed
end

if node[:phpfpm][:version] == '73'
  yum_package 'liblzf' do
    action [:install, :upgrade]
    options "--enablerepo=epel --disablerepo=amzn-main"
    notifies :run, 'bash[update-motd]', :delayed
  end
end

if node[:phpfpm][:version] >= '72'
  package 'php-mcrypt' do
    action [:remove]
    notifies :run, 'bash[update-motd]', :delayed
  end
end

node[:php][:packages].each do | pkg |
  if ! ( node[:phpfpm][:version] >= '72' && pkg == 'php-mcrypt' )
    yum_package pkg do
      action [:install, :upgrade]
      options "--skip-broken"
      notifies :run, 'bash[update-motd]', :delayed
      retries 2
      retry_delay 4
    end
  end
end

# configure php

%w{ php.ini php-fpm.conf php-fpm.d/www.conf }.each do | file_name |
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

# update www group

if node[:phpfpm][:enabled]
  group node[:php][:config][:group] do
    action :modify
    members [node[:php][:config][:user]]
    append true
  end
end

# php-fpm start

if node[:phpfpm][:enabled]
  service 'hhvm' do
    action [:stop, :disable]
  end
end

service "php-fpm" do
  action node[:phpfpm][:service_action]
end
