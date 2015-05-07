%w[
php-pecl-redis
php-pecl-igbinary
].map do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

package 'redis' do
  action [:install, :upgrade]
end

service 'redis' do
  action node[:redis][:service_action]
end
