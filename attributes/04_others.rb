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
