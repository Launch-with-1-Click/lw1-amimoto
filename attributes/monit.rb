default[:monit][:config_file]    = '/etc/monit.conf'
default[:monit][:config_dir]     = '/etc/monit.d'
default[:monit][:config][:alert] = []

default[:monit][:monitor] = {
  'nginx'     => node[:nginx][:enabled],
  'httpd'     => node[:httpd][:enabled],
  'hhvm'      => node[:hhvm][:enabled],
  'php-fpm'   => node[:phpfpm][:enabled],
  'mysql'     => node[:mysql][:enabled],
  'memcached' => node[:memcached][:enabled],
  'crond'     => true,
  'logging'   => true,
}

default[:monit][:source] = {
  'nginx'     => 'monit/nginx.erb',
  'httpd'     => 'monit/process_monitor.erb',
  'hhvm'      => 'monit/process_monitor.erb',
  'php-fpm'   => 'monit/php-fpm.erb',
  'mysql'     => 'monit/process_monitor.erb',
  'memcached' => 'monit/process_monitor.erb',
  'crond'     => 'monit/process_monitor.erb',
  'logging'   => 'monit/logging.erb'
}

default[:monit][:settings][:processes] = [
  {
   :name => 'nginx',
   :pidfile => '/var/run/nginx.pid',
   :start => '/sbin/service nginx start',
   :stop  => '/sbin/service nginx stop',
   :user  => node[:nginx][:config][:user],
   :group => node[:nginx][:config][:group],
   :rules => [
   ]
  },
  {
   :name => 'hhvm',
   :pidfile => '/var/tmp/hhvm.pid ',
   :start => '/sbin/service hhvm start',
   :stop  => '/sbin/service hhvm stop',
   :user  => node[:php][:config][:user],
   :group => node[:php][:config][:group],
   :rules => [
   ]
  },
  {
   :name => 'php-fpm',
   :pidfile => '/var/run/php-fpm/php-fpm.pid',
   :start => '/sbin/service php-fpm start',
   :stop  => '/sbin/service php-fpm stop',
   :user  => node[:php][:config][:user],
   :group => node[:php][:config][:group],
   :rules => [
   ]
  },
  {
   :name => 'mysql',
   :pidfile => '/var/run/mysqld/mysqld.pid',
   :start => '/sbin/service mysql start',
   :stop  => '/sbin/service mysql stop',
   :user  => node[:mysql][:config][:user],
   :group => node[:mysql][:config][:group],
   :rules => [
   ]
  },
  {
   :name => 'memcached',
   :pidfile => '/var/run/memcached/memcached.pid',
   :start => '/sbin/service memcached start',
   :stop  => '/sbin/service memcached stop',
   :rules => [
   ]
  },
  {
   :name => 'crond',
   :pidfile => '/var/run/crond.pid',
   :start => '/sbin/service crond start',
   :stop  => '/sbin/service crond stop',
   :rules => [
   ]
  },
  {
   :name => 'logging',
   :rules => [
   ]
  },
]
