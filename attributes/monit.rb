default[:monit][:config_file]    = '/etc/monit.conf'
default[:monit][:config_dir]     = '/etc/monit.d'
default[:monit][:config][:alert] = []

default[:monit][:source] = {
  'nginx'   => 'monit/nginx.erb',
  'php-fpm' => 'monit/php-fpm.erb',
  'mysql'   => 'monit/process_monitor.erb',
  'crond'   => 'monit/process_monitor.erb',
}
if node[:hhvm][:enabled]
  default[:monit][:source] = {
    'nginx'   => 'monit/nginx.erb',
    'hhvm'    => 'monit/process_monitor.erb',
    'mysql'   => 'monit/process_monitor.erb',
    'crond'   => 'monit/process_monitor.erb',
  }
end

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
   :name => 'crond',
   :pidfile => '/var/run/crond.pid',
   :start => '/sbin/service crond start',
   :stop  => '/sbin/service crond stop',
   :rules => [
   ]
  },
]
if node[:hhvm][:enabled]
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
     :name => 'crond',
     :pidfile => '/var/run/crond.pid',
     :start => '/sbin/service crond start',
     :stop  => '/sbin/service crond stop',
     :rules => [
     ]
    },
  ]
end
