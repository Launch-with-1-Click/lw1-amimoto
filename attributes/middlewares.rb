default[:web][:user] = 'nginx'
default[:web][:group] = 'nginx'
default[:web][:servername] = 'localhost'

## Nginx
default[:nginx][:enabled] = true
default[:nginx][:packages] = %w{ nginx }
default[:nginx][:service_action] = [:disable, :stop]
if node[:nginx][:enabled]
  default[:nginx][:service_action] = [:enable, :start]
end
default[:nginx][:config][:user] = node[:web][:user]
default[:nginx][:config][:group] = node[:web][:group]
default[:nginx][:config][:backend_upstream] = 'unix:/var/run/nginx-backend.sock'
default[:nginx][:config][:php_upstream] = 'unix:/var/run/php-fpm.sock'
default[:nginx][:config][:listen] = '80'
default[:nginx][:config][:listen_backend] = node[:nginx][:config][:backend_upstream]
default[:nginx][:config][:worker_processes] = node[:cpu][:total]
default[:nginx][:config][:client_max_body_size] = '4M'
default[:nginx][:config][:proxy_read_timeout] = '90'
default[:nginx][:config][:worker_rlimit_nofile] = '10240'
default[:nginx][:config][:worker_connections] = '8192'
default[:nginx][:config][:phpmyadmin_enable] = false
default[:nginx][:config][:wp_multisite] = false
default[:nginx][:config][:mobile_detect_enable] = false
default[:nginx][:config][:UA_ktai] = '(DoCoMo|J-PHONE|Vodafone|MOT-|UP\.Browser|DDIPOCKET|ASTEL|PDXGW|Palmscape|Xiino|sharp pda browser|Windows CE|L-mode|WILLCOM|SoftBank|Semulator|Vemulator|J-EMULATOR|emobile|mixi-mobile-converter|PSP)'
default[:nginx][:config][:UA_smartphone] ='(iPhone|iPod|incognito|webmate|Android|dream|CUPCAKE|froyo|BlackBerry|webOS|s8000|bada|IEMobile|Googlebot\-Mobile|AdsBot\-Google)'
default[:nginx][:config][:UA_smartphone_off] ='wptouch[^\\=]+\\=(normal|desktop)'

## Apache
default[:httpd][:enable] = false
default[:httpd][:packages] = %w{ httpd httpd-devel httpd-manual httpd-tools }
default[:httpd][:service_action] = [:stop, :disable]
if node[:httpd][:enable]
  default[:httpd][:service_action] = [:enable, :start]
end
default[:httpd][:config][:user]  = node[:web][:user]
default[:httpd][:config][:group] = node[:web][:group]
default[:httpd][:config][:servername] = node[:web][:servername]
default[:httpd][:config][:listen] = '80'
if node[:nginx][:enable]
  default[:httpd][:config][:listen] = '8080'
end
default[:httpd][:config][:allow_override] = 'NONE'

## hhvm
default[:hhvm][:enabled] = false
default[:hhvm][:service_action] = [:disable, :stop]
if node[:hhvm][:enabled]
  default[:hhvm][:service_action] = [:enable, :start]
end
default[:hhvm][:config][:user] = node[:web][:user]
default[:hhvm][:config][:group] = node[:web][:group]
default[:hhvm][:config][:listen] = '9001'
default[:hhvm][:config][:file_socket] = '/var/tmp/hiphop-php.sock'
if node[:hhvm][:enabled]
  default[:nginx][:config][:php_upstream] = 'unix:/var/tmp/hiphop-php.sock'
end


## PHP
default[:phpfpm][:enabled] = true
if node[:hhvm][:enabled]
  default[:phpfpm][:enabled] = false
end
default[:phpfpm][:service_action] = [:disable, :stop]
if node[:phpfpm][:enabled]
  default[:phpfpm][:service_action] = [:enable, :start]
end

default[:php][:packages] = %w{ php php-cli php-fpm php-devel php-mbstring php-gd php-pear php-xml php-mcrypt php-mysqlnd php-pdo php-pecl-zendopcache }
default[:php][:config][:user] = node[:web][:user]
default[:php][:config][:group] = node[:web][:group]
default[:php][:config][:listen] = '/var/run/php-fpm.sock'
if node[:phpfpm][:enabled]
  default[:nginx][:config][:php_upstream] = 'unix:/var/run/php-fpm.sock'
end
default[:php][:config][:listen_backlog] = '65536'
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
default[:mysql][:enabled] = true
default[:mysql][:packages] = %w{ Percona-Server-server-56 Percona-Server-client-56 }
default[:mysql][:service_action] = [:disable, :stop]
if node[:mysql][:enabled]
  default[:mysql][:service_action] = [:enable, :start]
end
default[:mysql][:config][:user] = 'mysql'
default[:mysql][:config][:group] = 'mysql'
default[:mysql][:config][:innodb_buffer_pool_size] = '64M'
default[:mysql][:config][:innodb_log_file_size] = '16M'
default[:mysql][:config][:query_cache_size] = '64M'
default[:mysql][:config][:tmp_table_size]  = '64M'
default[:mysql][:config][:max_connections] = '128'
default[:mysql][:config][:thread_cache] = '128'

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


case node[:ec2][:instance_type]
when "t1.micro"
  ## memcached
  default[:memcached][:enabled] = false
  default[:memcached][:service_action] = [:stop, :disable]

  ## redis
  default[:redis][:enabled] = false
  default[:redis][:service_action] = [:stop, :disable]

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
when "t2.micro"
  ## memcached
  default[:memcached][:enabled] = false
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
end
