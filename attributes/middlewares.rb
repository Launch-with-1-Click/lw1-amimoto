## memcached
default[:memcached][:packages] = %w{ memcached }
default[:memcached][:service_action] = [:enable, :start]

## Nginx
default[:nginx][:packages] = %w{ nginx }
default[:nginx][:service_action] = [:enable, :start]
default[:nginx][:config][:user] = 'nginx'
default[:nginx][:config][:group] = 'nginx'
default[:nginx][:config][:worker_processes] = '2'
default[:nginx][:config][:client_max_body_size] = '4M'
default[:nginx][:config][:proxy_read_timeout] = '90'
default[:nginx][:config][:worker_rlimit_nofile] = '10240'
default[:nginx][:config][:worker_connections] = '8192'
##default[:nginx][:config][:phpmyadmin_enable] = true

## PHP
default[:php][:packages] = %w{ php php-cli php-fpm php-devel php-mbstring php-gd php-pear php-xml php-mcrypt php-mysqlnd php-pdo php-pecl-memcache }
default[:php][:service_action] = [:enable, :start]
default[:php][:config][:user] = 'nginx'
default[:php][:config][:group] = 'nginx'
default[:php][:config][:max_children] = '5'
default[:php][:config][:start_servers] = '1'
default[:php][:config][:min_spare_servers] = '1'
default[:php][:config][:max_spare_servers] = '4'
default[:php][:config][:max_requests] = '200'
default[:php][:config][:upload_max_filesize] = node[:nginx][:config][:client_max_body_size]
default[:php][:config][:post_max_size] = node[:php][:config][:upload_max_filesize]
default[:php][:config][:request_terminate_timeout] = node[:nginx][:config][:proxy_read_timeout]
default[:php][:config][:max_execution_time] = node[:nginx][:config][:proxy_read_timeout]

## MySQL
default[:mysql][:packages] = %w{ Percona-Server-server-56 Percona-Server-client-56 }
default[:mysql][:service_action] = [:enable, :start]
default[:mysql][:config][:user] = 'mysql'
default[:mysql][:config][:group] = 'mysql'
default[:mysql][:config][:innodb_buffer_pool_size] = '64M'
default[:mysql][:config][:innodb_log_file_size] = '16M'
default[:mysql][:config][:query_cache_size] = '64M'
default[:mysql][:config][:tmp_table_size]  = '64M'
default[:mysql][:config][:max_connections] = '128'
default[:mysql][:config][:thread_cache] = '128'

case node[:ec2][:instance_type]
when "t2.micro"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '5'
  default[:php][:config][:start_servers] = '1'
  default[:php][:config][:min_spare_servers] = '1'
  default[:php][:config][:max_spare_servers] = '4'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '128M'
  default[:mysql][:config][:query_cache_size] = '64M'
  default[:mysql][:config][:tmp_table_size]  = '64M'
  default[:mysql][:config][:max_connections] = '128'
  default[:mysql][:config][:thread_cache] = '128'
when "t2.small"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '5'
  default[:php][:config][:start_servers] = '1'
  default[:php][:config][:min_spare_servers] = '1'
  default[:php][:config][:max_spare_servers] = '4'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '128M'
  default[:mysql][:config][:query_cache_size] = '128M'
  default[:mysql][:config][:tmp_table_size]  = '128M'
  default[:mysql][:config][:max_connections] = '128'
  default[:mysql][:config][:thread_cache] = '128'
when "t2.medium"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m3.medium"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m3.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m3.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m3.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m1.small"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '1'

  ## PHP
  default[:php][:config][:max_children] = '5'
  default[:php][:config][:start_servers] = '1'
  default[:php][:config][:min_spare_servers] = '1'
  default[:php][:config][:max_spare_servers] = '4'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '128M'
  default[:mysql][:config][:query_cache_size] = '128M'
  default[:mysql][:config][:tmp_table_size]  = '128M'
  default[:mysql][:config][:max_connections] = '128'
  default[:mysql][:config][:thread_cache] = '128'
when "m1.medium"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m1.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m1.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c3.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c3.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c3.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c3.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c3.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '32'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c4.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c4.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c4.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c4.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c4.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '32'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c1.medium"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "c1.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "cc2.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '32'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "g2.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "cg1.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '16'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m2.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m2.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "m2.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '10'
  default[:php][:config][:min_spare_servers] = '10'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "cr1.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '32'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "i2.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '4'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "i2.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "i2.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '16'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "i2.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '32'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "hs1.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '16'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "hi1.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '16'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '512M'
  default[:mysql][:config][:query_cache_size] = '512M'
  default[:mysql][:config][:tmp_table_size]  = '512M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "r3.large"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '20'
  default[:php][:config][:start_servers] = '4'
  default[:php][:config][:min_spare_servers] = '4'
  default[:php][:config][:max_spare_servers] = '16'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "r3.xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "r3.2xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "r3.4xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '8'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "r3.8xlarge"
  ## Nginx
  default[:nginx][:config][:worker_processes] = '32'

  ## PHP
  default[:php][:config][:max_children] = '35'
  default[:php][:config][:start_servers] = '5'
  default[:php][:config][:min_spare_servers] = '5'
  default[:php][:config][:max_spare_servers] = '25'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '256M'
  default[:mysql][:config][:query_cache_size] = '256M'
  default[:mysql][:config][:tmp_table_size]  = '256M'
  default[:mysql][:config][:max_connections] = '256'
  default[:mysql][:config][:thread_cache] = '256'
when "t1.micro"
  ## memcached
  default[:memcached][:service_action] = [:stop, :disable]

  ## Nginx
  default[:nginx][:config][:worker_processes] = '2'

  ## PHP
  default[:php][:config][:max_children] = '5'
  default[:php][:config][:start_servers] = '1'
  default[:php][:config][:min_spare_servers] = '1'
  default[:php][:config][:max_spare_servers] = '4'
  default[:php][:config][:max_requests] = '200'

  ## MySQL
  default[:mysql][:config][:innodb_buffer_pool_size] = '64M'
  default[:mysql][:config][:query_cache_size] = '64M'
  default[:mysql][:config][:tmp_table_size]  = '64M'
  default[:mysql][:config][:max_connections] = '128'
  default[:mysql][:config][:thread_cache] = '128'
end
