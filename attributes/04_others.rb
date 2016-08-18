## memcached
default[:memcached][:enabled] = true
default[:memcached][:service_action] = [:disable, :stop]
if node[:memcached][:enabled]
  default[:memcached][:service_action] = [:enable, :start]
  default[:php][:packages].push('php-pecl-memcache')
  default[:mod_php7][:packages].push('php70-php-pecl-memcache')
end

## redis
default[:redis][:enabled] = false
default[:redis][:service_action] = [:disable, :stop]
if node[:redis][:enabled]
  default[:redis][:service_action] = [:enable, :start]
end

## goofys
default[:goofys][:install] = false
default[:goofys][:version] = '0.0.6'
default[:goofys][:packages] = %w{
  golang
  fuse
  }
default[:goofys][:source_url] = 'https://github.com/kahing/goofys/releases/download/v' + node[:goofys][:version] + '/goofys'
default[:goofys][:mount] = false
default[:goofys][:config][:profile] = 'default'
default[:goofis][:config][:reagion] = 'us-east-1'
default[:goofys][:config][:s3_bucket] = 's3_bucket_name'
default[:goofys][:config][:mount_point] = '/mnt/s3'

## letsencrypt
default[:letsencrypt][:install] = false
