require 'securerandom'

# install nginx
include_recipe 'amimoto::nginx'

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
    :table_prefix => node[:wordpress][:table_prefix]
  )
  source "wordpress/wp-config.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end

## create local-config.php
#template "/var/www/vhosts/" + node[:wordpress][:servername] + "/local-config.php" do
#  variables(
#    :db_name => node[:wordpress][:db][:dbname],
#    :user_name => node[:wordpress][:db][:user],
#    :password => node[:wordpress][:db][:pass]
#  )
#  source "wordpress/local-config.php.erb"
#  notifies :run, 'bash[wp-download]', :immediately
#end

# create salt.php
template "/var/www/vhosts/" + node[:wordpress][:servername] + "/salt.php" do
  variables(
    :auth_key => SecureRandom.base64(64),
    :secure_auth_key => SecureRandom.base64(64),
    :logged_in_key => SecureRandom.base64(64),
    :nonce_key => SecureRandom.base64(64),
    :auth_salt => SecureRandom.base64(64),
    :secure_auth_salt => SecureRandom.base64(64),
    :logged_in_salt => SecureRandom.base64(64),
    :nonce_salt => SecureRandom.base64(64)
  )
  source "wordpress/salt.php.erb"
  notifies :run, 'bash[wp-download]', :immediately
end
