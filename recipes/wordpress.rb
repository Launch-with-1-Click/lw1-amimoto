require 'securerandom'

# install nginx
include_recipe 'amimoto::nginx'

# install mysql
include_recipe 'amimoto::mysql'

# install wp-cli
include_recipe 'amimoto::wpcli'

# create web document root
%W{ /opt/local/amimoto /opt/local/amimoto/wp-admin #{node[:wordpress][:document_root]} }.each do | dir_name |
  directory dir_name do
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00775
    recursive true
    action :create
  end
end

template "/opt/local/amimoto/wp-admin/install.php" do
  owner node[:nginx][:config][:user]
  group node[:nginx][:config][:group]
  mode 00755
  variables(
    :instance_id => node[:ec2][:instance_id]
  )
  source "install.php.erb"
end

# config files
%w{ drop mobile-detect phpmyadmin php-fpm wp-front wp-multisite-subdir wp-singlesite }.each do | file_name |
  template "/etc/nginx/" + file_name do
    variables node[:nginx][:config]
    source "nginx/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

%w{ 00_real_ip.conf 01_expires_map.conf }.each do | file_name |
  template "/etc/nginx/conf.d/" + file_name do
    variables node[:nginx][:config]
    source "nginx/conf.d/" + file_name + ".erb"
    notifies :reload, 'service[nginx]'
  end
end

# site_name.conf
site_conf = "/etc/nginx/conf.d/" + node[:wordpress][:servername] + '.conf'
if node[:wordpress][:servername] == node[:ec2][:instance_id] then
	site_conf = "/etc/nginx/conf.d/default.conf"
end
template site_conf do
  variables(
    :listen => node[:nginx][:config][:listen],
    :listen_backend => node[:nginx][:config][:listen_backend],
    :server_name => node[:wordpress][:servername],
    :document_root => node[:wordpress][:document_root],
    :wp_multisite => node[:wordpress][:wp_multisite],
    :mobile_detect_enable => node[:wordpress][:mobile_detect_enable],
    :phpmyadmin_enable => node[:wordpress][:phpmyadmin_enable]
  )
  source "nginx/conf.d/default.conf.erb"
  notifies :reload, 'service[nginx]'
end

# site_name-ssl.conf
if node[:nginx][:http2_enable]
  site_ssl_conf = "/etc/nginx/conf.d/" + node[:wordpress][:servername] + '-ssl.conf'
  if node[:wordpress][:servername] == node[:ec2][:instance_id] then
      site_ssl_conf = "/etc/nginx/conf.d/default-ssl.conf"
  end
  template site_ssl_conf do
    variables(
      :listen => node[:nginx][:config][:listen_ssl],
      :listen_backend => node[:nginx][:config][:listen_backend],
      :server_name => node[:wordpress][:servername],
      :document_root => node[:wordpress][:document_root],
      :wp_multisite => node[:wordpress][:wp_multisite],
      :mobile_detect_enable => node[:wordpress][:mobile_detect_enable],
      :phpmyadmin_enable => node[:wordpress][:phpmyadmin_enable]
    )
    source "nginx/conf.d/default-ssl.conf.erb"
    notifies :restart, 'service[nginx]'
  end
end

# site_name.backend.conf
site_backend_conf = "/etc/nginx/conf.d/" + node[:wordpress][:servername] + '.backend.conf'
if node[:wordpress][:servername] == node[:ec2][:instance_id] then
	site_backend_conf = "/etc/nginx/conf.d/default.backend.conf"
end
template site_backend_conf do
  variables(
    :listen => node[:nginx][:config][:listen],
    :listen_backend => node[:nginx][:config][:listen_backend],
    :server_name => node[:wordpress][:servername],
    :document_root => node[:wordpress][:document_root],
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
  umask '0002'
  cwd "/tmp"
  code <<-EOH
    wp --allow-root --path=#{node[:wordpress][:document_root]} --version=#{node[:wordpress][:version]} --force core download
    chown -R #{node[:nginx][:config][:user]}:#{node[:nginx][:config][:group]} #{node[:wordpress][:document_root]}
  EOH
end

# create wp-config.php
template node[:wordpress][:document_root] + "/wp-config.php" do
  variables(
    :servername => node[:wordpress][:servername],
    :table_prefix => node[:wordpress][:table_prefix],
    :wp_multisite => node[:wordpress][:wp_multisite]
  )
  source "wordpress/wp-config.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end

## create local-config.php
template node[:wordpress][:document_root] + "/local-config.php" do
  variables node[:wordpress][:db]
  source "wordpress/local-config.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end

# create local-salt.php
template node[:wordpress][:document_root] + "/local-salt.php" do
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

# install plugins
node[:wordpress][:plugins].each do | plugin_name |
  amimoto_wpplugin "install #{plugin_name}" do
    plugin_name plugin_name
    install_path node[:wordpress][:document_root]
    action :install
  end
end

# install mu-plugins
mu_plugins_path = node[:wordpress][:document_root] + "/wp-content/mu-plugins"
directory mu_plugins_path do
  owner node[:nginx][:config][:user]
  group node[:nginx][:config][:group]
  mode 00775
  recursive true
  action :create
end

node[:wordpress][:mu_plugins].each do | file_name |
  template mu_plugins_path + "/" + file_name do
    owner node[:nginx][:config][:user]
    group node[:nginx][:config][:group]
    mode 00664
    variables node[:nginx][:config]
    source "wordpress/wp-content/mu-plugins/" + file_name + ".erb"
  end
end

# install themes
node[:wordpress][:themes].each do | theme_name |
  amimoto_wptheme "install #{theme_name}" do
    theme_name theme_name
    install_path node[:wordpress][:document_root]
    action :install
  end
end

# update-motd
include_recipe 'amimoto::update-motd'
