# memcached install
pecl_pkg = 'php-pecl-memcache'
if node[:mod_php7][:enabled]
  pecl_pkg = 'php70-php-pecl-memcache'
end
package pecl_pkg do
  action [:install, :upgrade]
  notifies :run, 'bash[update-motd]', :delayed
end

package 'memcached' do
  action [:install, :upgrade]
  options '--disablerepo=remi'
  notifies :run, 'bash[update-motd]', :delayed
end

service "memcached" do
  action node[:memcached][:service_action]
end
