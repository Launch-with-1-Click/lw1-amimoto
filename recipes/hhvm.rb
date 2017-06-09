# create www Group
group node[:hhvm][:config][:group] do
  members ['ec2-user',node[:hhvm][:config][:user]]
  action :create
end

# php install

## for avoid confricts between amzn and remi.
# node.override[:php][:packages] = node[:php][:packages] - %w{ }
package "php55-common" do
  action [:remove]
end

include_recipe 'amimoto::php'

# remove  old depends repo
file "/etc/yum.repos.d/hop5.repo" do
  action :delete
end

# hhvm install
%w{ opsrock-hhvm-depends.repo opsrock-hhvm.repo }.each do | file_name |
  template "/etc/yum.repos.d/" + file_name do
    source "yum/" + file_name + ".erb"
  end
end

%w[ glog tbb ].map do |pkg|
  yum_package pkg do
    action [:install, :upgrade]
    options '-y --nogpgcheck'
    notifies :run, 'bash[update-motd]', :delayed
  end
end

yum_package 'libmemcached'
yum_package 'hhvm' do
  action [:install]
  options '-y --nogpgcheck'
  notifies :run, 'bash[update-motd]', :delayed
end

# hhvm configure

template "/etc/hhvm/server.ini" do
  variables node[:hhvm][:config]
  source "hhvm/server.ini.erb"
  if node[:hhvm][:enabled]
    notifies :restart, 'service[hhvm]'
  end
end

template "/etc/hhvm/php.ini" do
  variables node[:php][:config]
  source "php/php.ini.erb"
  if node[:hhvm][:enabled]
    notifies :restart, 'service[hhvm]'
  end
end

template "/etc/logrotate.d/hhvm" do
  variables node[:hhvm][:config]
  source "logrotat.d/hhvm.erb"
end

# update www groups
if node[:hhvm][:enabled]
  group node[:hhvm][:config][:group] do
    action :modify
    members [node[:hhvm][:config][:user]]
    append true
  end
end

# hhvm start
if node[:hhvm][:enabled]
  service "php-fpm" do
    action [:stop, :disable]
  end
end

service 'hhvm' do
  action node[:hhvm][:service_action]
end
