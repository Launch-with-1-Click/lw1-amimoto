# memcached install
pecl_pkg = 'php-pecl-memcache'
if node[:mod_php7][:enabled]
  pecl_pkg = 'php70-php-pecl-memcache'
end
package pecl_pkg do
  action [:install, :upgrade]
end

#%w{ php.d/memcache.ini }.each do | file_name |
#  template "/etc/" + file_name do
#    variables node[:php][:config]
#    source "php/" + file_name + ".erb"
#    notifies :reload, 'service[php-fpm]'
#  end
#end

package 'memcached' do
  action [:install, :upgrade]
  options '--disablerepo=remi'
end

service "memcached" do
  action node[:memcached][:service_action]
end
