### mod_php7
default[:mod_php7][:enabled] = false
default[:mod_php7][:install_checker] = '127.0.0.1:8081'
default[:mod_php7][:packages] = %w{
  php70-php
  php70-mod_php
  php70-php-cli
  php70-php-fpm
  php70-php-devel
  php70-php-mbstring
  php70-php-gd
  php70-php-pear
  php70-php-xml
  php70-php-mcrypt
  php70-php-mysqlnd
  php70-php-pdo
  php70-php-opcache
  }
if node[:mod_php7][:enabled]
  force_default[:httpd][:enabled] = true
  force_default[:httpd][:service_action] = [:enable, :start]
  force_default[:httpd][:config][:listen] = '8080'
  force_default[:httpd][:config][:allow_override] = 'ALL'
  force_default[:nginx][:config][:backend_upstream] = '127.0.0.1:8080'
  force_default[:phpfpm][:enabled] = false
  force_default[:phpfpm][:service_action] = [:disable, :stop]
  force_default[:httpd][:config][:keep_alive_timeout] = 120
end

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
default[:phpfpm][:version] = '56'
if node[:hhvm][:enabled]
  default[:phpfpm][:enabled] = false
end
default[:phpfpm][:service_action] = [:disable, :stop]
if node[:phpfpm][:enabled]
  default[:phpfpm][:service_action] = [:enable, :start]
end

default[:php][:packages] = %w{
  php
  php-cli
  php-fpm
  php-devel
  php-mbstring
  php-gd
  php-pear
  php-xml
  php-mcrypt
  php-mysqlnd
  php-pdo
  php-opcache
  }
default[:php][:config][:user] = node[:web][:user]
default[:php][:config][:group] = node[:web][:group]
default[:php][:config][:listen] = '/var/run/php-fpm.sock'
if node[:phpfpm][:enabled]
  default[:nginx][:config][:php_upstream] = 'unix:/var/run/php-fpm.sock'
end
default[:php][:config][:listen_backlog] = '65536'
default[:php][:config][:rlimit_files] = '131072'
default[:php][:config][:rlimit_core] = '0'
default[:php][:config][:pm] = 'dynamic'
default[:php][:config][:max_children] = '5'
default[:php][:config][:start_servers] = '1'
default[:php][:config][:min_spare_servers] = '1'
default[:php][:config][:max_spare_servers] = '4'
default[:php][:config][:memory_limit] = '128M'
default[:php][:config][:max_requests] = '200'
default[:php][:config][:max_input_vars] = '1000'
default[:php][:config][:max_input_time] = '60'
default[:php][:config][:max_input_nesting_level] = '64'
default[:php][:config][:upload_max_filesize] = node[:nginx][:config][:client_max_body_size]
default[:php][:config][:post_max_size] = node[:php][:config][:upload_max_filesize]
default[:php][:config][:request_terminate_timeout] = node[:nginx][:config][:proxy_read_timeout]
default[:php][:config][:max_execution_time] = node[:nginx][:config][:proxy_read_timeout]
default[:php][:config][:session_save_hundler] = 'files'
default[:php][:config][:session_save_path] = '/var/tmp/php/session'
default[:php][:config][:sendmail_path] = '/usr/sbin/sendmail -t -i'
default[:php][:config][:limit_extensions] = '.php'
