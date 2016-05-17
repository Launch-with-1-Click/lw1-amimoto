require 'securerandom'

# install nginx
include_recipe 'amimoto::nginx'

# install mysql
include_recipe 'amimoto::mysql'

# install wp-cli
include_recipe 'amimoto::wpcli'

# create web document root and /etc/nginx/conf.d/*.conf
directory "/var/www/vhosts/" + node[:wordpress][:servername] do
  owner node[:nginx][:config][:user]
  group node[:nginx][:config][:group]
  mode 00755
  recursive true
  action :create
end

# expires map
template "/etc/nginx/conf.d/01_expires_map.conf" do
  variables node[:nginx][:config]
  source "nginx/conf.d/01_expires_map.conf.erb"
  notifies :reload, 'service[nginx]'
end

# site_name.conf
template "/etc/nginx/conf.d/" + node[:wordpress][:servername] + '.conf' do
  variables(
    :listen => node[:nginx][:config][:listen],
    :listen_backend => node[:nginx][:config][:listen_backend],
    :server_name => node[:wordpress][:servername],
    :wp_multisite => node[:wordpress][:wp_multisite],
    :mobile_detect_enable => node[:wordpress][:mobile_detect_enable],
    :phpmyadmin_enable => node[:wordpress][:phpmyadmin_enable]
  )
  source "nginx/conf.d/default.conf.erb"
  notifies :reload, 'service[nginx]'
end

# site_name.backend.conf
template "/etc/nginx/conf.d/" + node[:wordpress][:servername] + '.backend.conf' do
  variables(
    :listen => node[:nginx][:config][:listen],
    :listen_backend => node[:nginx][:config][:listen_backend],
    :server_name => node[:wordpress][:servername],
    :wp_multisite => node[:wordpress][:wp_multisite],
    :mobile_detect_enable => node[:wordpress][:mobile_detect_enable],
    :phpmyadmin_enable => node[:wordpress][:phpmyadmin_enable]
  )
  source "nginx/conf.d/default.backend.conf.erb"
  notifies :reload, 'service[nginx]'
end

# download WordPress core source
bash "wp-download" do
  action :nothing
  user "root"
  cwd "/tmp"
  code <<-EOH
    wp --allow-root --path=#{::File.join("/var/www/vhosts/",node[:wordpress][:servername])} --version=#{node[:wordpress][:version]} --force core download
    chown -R #{node[:nginx][:config][:user]}:#{node[:nginx][:config][:group]} #{::File.join("/var/www/vhosts/",node[:wordpress][:servername])}
  EOH
end

# create wp-config.php
template "/var/www/vhosts/" + node[:wordpress][:servername] + "/wp-config.php" do
  variables(
    :servername => node[:wordpress][:servername],
    :table_prefix => node[:wordpress][:table_prefix],
    :wp_multisite => node[:wordpress][:wp_multisite]
  )
  source "wordpress/wp-config.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end

## create local-config.php
template "/var/www/vhosts/" + node[:wordpress][:servername] + "/local-config.php" do
  variables node[:wordpress][:db]
  source "wordpress/local-config.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end

# create local-salt.php
template "/var/www/vhosts/" + node[:wordpress][:servername] + "/local-salt.php" do
  variables node[:wordpress][:salt]
  source "wordpress/local-salt.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end

# create MySQL User and Database
create_db_sql = "/opt/local/createdb-" + node[:wordpress][:servername] + '.sql'
execute "mysql-create-database" do
  command "/usr/bin/mysql -u root --password='#{node['wordpress']['db']['rootpass']}' < #{create_db_sql}"
  action :nothing
end
 
template create_db_sql do
  owner "root"
  group "root"
  mode "0600"
  variables node[:wordpress][:db]
  source "wordpress/createdb.sql.erb"
  notifies :run, "execute[mysql-create-database]", :immediately
end
