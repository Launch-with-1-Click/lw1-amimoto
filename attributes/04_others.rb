## memcached
default[:memcached][:enabled] = true
default[:memcached][:service_action] = [:disable, :stop]
if node[:memcached][:enabled]
  default[:memcached][:service_action] = [:enable, :start]
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
