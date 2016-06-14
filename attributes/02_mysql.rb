## MySQL
default[:mysql][:enabled] = true
default[:mysql][:packages] = %w{
  Percona-Server-server-56
  Percona-Server-client-56
  }
default[:mysql][:service_action] = [:disable, :stop]
if node[:mysql][:enabled]
  default[:mysql][:service_action] = [:enable, :start]
end
default[:mysql][:config][:user] = 'mysql'
default[:mysql][:config][:group] = 'mysql'
default[:mysql][:config][:max_allowed_packet] = '1M'
default[:mysql][:config][:innodb_buffer_pool_size] = '64M'
default[:mysql][:config][:innodb_log_file_size] = '16M'
default[:mysql][:config][:innodb_buffer_pool_instances] = '1'
default[:mysql][:config][:query_cache_size] = '64M'
default[:mysql][:config][:tmp_table_size]  = '64M'
default[:mysql][:config][:max_connections] = '128'
default[:mysql][:config][:thread_cache] = '128'
default[:mysql][:config][:sort_buffer_size] = '512K'
default[:mysql][:config][:read_buffer_size] = '256K'
default[:mysql][:config][:read_rnd_buffer_size] = '256K'
default[:mysql][:config][:join_buffer_size] = '256K'