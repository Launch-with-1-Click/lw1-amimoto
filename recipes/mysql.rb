# Percona install

cookbook_file "#{Chef::Config[:file_cache_path]}/percona-release-0.0-1.x86_64.rpm" do
  source "percona-release-0.0-1.x86_64.rpm"
end

package "percona-release" do
  source "#{Chef::Config[:file_cache_path]}/percona-release-0.0-1.x86_64.rpm"
  action :install
  provider Chef::Provider::Package::Rpm
  ignore_failure true
end

node[:mysql][:packages].each do |package_name|
  yum_package package_name do
    action [:install, :upgrade]
    if ['redhat'].include?(node[:platform])
      flush_cache [:before]
    end
  end
end


# configure mysql

directory '/var/run/mysqld' do
  action :create
  mode '0700'
  owner node[:mysql][:config][:user]
  group node[:mysql][:config][:group]
end

template "/etc/my.cnf" do
  variables node[:mysql][:config]
  source "mysql/my.cnf.erb"
  notifies :reload, 'service[mysql]' unless node.run_state[:mysql_flush_ib_logfiles]
end

file "/var/log/mysqld-slow.log" do
  owner node[:mysql][:config][:user]
  group "root"
  mode "0640"
  action :create
end

template "/etc/logrotate.d/mysql" do
  variables node[:mysql][:config]
  source "logrotat.d/mysql.erb"
end

service "mysql" do
  action node[:mysql][:service_action]
end

## check innodb_log_file_size
node.run_state[:mysql_flush_ib_logfiles] = false
current_innodb_log_file_size =  get_mysql_variable("innodb_log_file_size")
new_innodb_log_file_size =  to_mysql_bytes(node[:mysql][:config][:innodb_log_file_size])

unless current_innodb_log_file_size == new_innodb_log_file_size
  node.run_state[:mysql_flush_ib_logfiles] = true
end


## restart with flush innodb_log_files

if node.run_state[:mysql_flush_ib_logfiles]
  restart_mysql_with_flush_ib_logfiles
end

node.run_state.delete(:mysql_flush_ib_logfiles)
