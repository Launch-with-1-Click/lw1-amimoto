#!/bin/sh
PHP_MY_ADMIN_VER="4.5.3.1"
AMIMOTO_BRANCH='2016.01'

INSTANCETYPE=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-type)
INSTANCEID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)

SERVERNAME=${INSTANCEID}

if [ -f /usr/bin/python2.7 ]; then
  /usr/sbin/alternatives --set python /usr/bin/python2.7
elif [ -f /usr/bin/python2.6 ]; then
  /usr/sbin/alternatives --set python /usr/bin/python2.6
fi

/usr/bin/yum clean all

/sbin/service monit stop
/sbin/service mysql stop

/bin/cp /dev/null /root/.mysql_history > /dev/null 2>&1
/bin/cp /dev/null /root/.bash_history > /dev/null 2>&1
/bin/cp /dev/null /home/ec2-user/.bash_history > /dev/null 2>&1
/bin/rm -rf /var/www/vhosts/i-* > /dev/null 2>&1
/bin/rm -rf /opt/local/amimoto > /dev/null 2>&1
/usr/bin/yes | /usr/bin/crontab -r
echo '@reboot /bin/sh /opt/local/provision > /dev/null 2>&1' | crontab

if [ ! -d /var/www/vhosts/${SERVERNAME} ]; then
  /bin/mkdir -p /var/www/vhosts/${SERVERNAME}
fi
echo '<html>
<head>
<title>Setting up your WordPress now.</title>
</head>
 <body>
<p>Setting up your WordPress now.</p>
<p>After a while please reload your web browser.</p>
</body>' > /var/www/vhosts/${SERVERNAME}/index.html

/usr/bin/git -C /opt/local/chef-repo/cookbooks/amimoto/ pull origin ${AMIMOTO_BRANCH} || \
  /usr/bin/git -C /opt/local/chef-repo/cookbooks/amimoto/ pull mirror ${AMIMOTO_BRANCH}
if [ "t1.micro" != "${INSTANCETYPE}" ]; then
  if [ -f /etc/php-fpm.d/www.conf ]; then
    /bin/rm -f /etc/php-fpm.d/www.conf
  fi
  if [ -f /etc/nginx/nginx.conf ]; then
    /bin/rm -f /etc/nginx/nginx.conf
  fi
  if [ -f /etc/nginx/conf.d/default.conf ]; then
    /bin/rm -f /etc/nginx/conf.d/default.*
  fi
  /usr/bin/chef-solo -c /opt/local/solo.rb -j /opt/local/amimoto.json - l error
elif [ "t1.micro" = "${INSTANCETYPE}" ]; then
  /sbin/chkconfig memcached off
  /sbin/service memcached stop
fi
if [ ! -f /etc/nginx/nginx.conf ]; then
  /usr/bin/chef-solo -o amimoto::nginx -c /opt/local/solo.rb -j /opt/local/amimoto.json -l error
fi
if [ ! -f /etc/nginx/conf.d/default.conf ]; then
  /usr/bin/chef-solo -o amimoto::nginx_default -c /opt/local/solo.rb -j /opt/local/amimoto.json -l error
fi
if [ ! -f /etc/php-fpm.d/www.conf ]; then
  /usr/bin/chef-solo -o amimoto::php -c /opt/local/solo.rb -j /opt/local/amimoto.json -l error
fi

CF_PATTERN=$(/usr/bin/php /opt/local/cf_patern_check.php)
if [ "$CF_PATTERN" = "nfs_server" ]; then
  /usr/bin/chef-solo -o amimoto::nfs_dispatcher -c /opt/local/solo.rb -j /opt/local/amimoto.json -l error
fi
if [ "$CF_PATTERN" = "nfs_client" ]; then
  /usr/bin/chef-solo -o amimoto::nfs_dispatcher -c /opt/local/solo.rb -j /opt/local/amimoto.json -l error
fi

if [ -f /usr/sbin/getenforce ]; then
  if [ "Enforcing" = "`/usr/sbin/getenforce`" ]; then
    /usr/bin/yum install -y setools-console
    /usr/sbin/semanage fcontext -a -t httpd_sys_content_t "/opt/local/amimoto(/.*)?"
    /sbin/restorecon -R -v /opt/local/amimoto/
  fi
fi

# clear log files
/sbin/service monit stop

/sbin/service nginx stop
/bin/rm -rf /var/log/nginx/*
/bin/rm -rf /var/cache/nginx/*
/sbin/service nginx start

/sbin/service php-fpm stop
/bin/rm -rf /var/log/php-fpm/*
/sbin/service php-fpm start

/sbin/service mysql stop
/bin/rm -f /var/lib/mysql/ib_logfile*
/bin/rm -f /var/log/mysqld.log*
/sbin/service mysql start

/sbin/service monit start

if [ "$CF_PATTERN" != "nfs_client" ]; then
  echo "WordPress install ..."
  cd /opt/local
  if [ ! -f /opt/local/${SERVERNAME}.json ]; then
    /usr/local/bin/wp-setup-json ${SERVERNAME} | /usr/bin/jq '.' > /opt/local/${SERVERNAME}.json
    chmod 0600 /opt/local/${SERVERNAME}.json
  fi
  /bin/cp -r /opt/local/${SERVERNAME}.json /tmp/wp-setup.json
  if [ -f /opt/local/amimoto.json ]; then
    /usr/bin/jq -s '.[0] * .[1]' /opt/local/${SERVERNAME}.json /opt/local/amimoto.json > /tmp/wp-setup.json
  fi
  if [ -f /var/www/vhosts/${SERVERNAME}/wp-content/object-cache.php ]; then
    /bin/rm -f /var/www/vhosts/${SERVERNAME}/wp-content/object-cache.php
  fi
  /usr/bin/chef-solo -o amimoto::wordpress -c /opt/local/solo.rb -j /tmp/wp-setup.json -l error
  /bin/rm -f /tmp/wp-setup.json

  echo "... WordPress installed"

  /bin/rm -f /var/www/vhosts/${SERVERNAME}/index.html
  /bin/chown -R nginx:nginx /var/cache/nginx
  /bin/chown -R nginx:nginx /var/www/vhosts/${SERVERNAME}
fi

/bin/chown -R nginx:nginx /var/log/nginx
/bin/chown -R nginx:nginx /var/log/php-fpm
/bin/chown -R nginx:nginx /var/tmp/php
/bin/chown -R nginx:nginx /var/lib/php
/bin/chmod +x /usr/local/bin/wp-setup

# install phpMyAdmin
cd /usr/share/
if [ ! -d /usr/share/phpMyAdmin-${PHP_MY_ADMIN_VER}-all-languages ] ; then
  /usr/bin/wget https://files.phpmyadmin.net/phpMyAdmin/${PHP_MY_ADMIN_VER}/phpMyAdmin-${PHP_MY_ADMIN_VER}-all-languages.zip
  if [ -f phpMyAdmin-${PHP_MY_ADMIN_VER}-all-languages.zip ]; then
    /usr/bin/unzip /usr/share/phpMyAdmin-${PHP_MY_ADMIN_VER}-all-languages.zip
    /bin/rm /usr/share/phpMyAdmin-${PHP_MY_ADMIN_VER}-all-languages.zip
    /bin/rm /usr/share/phpMyAdmin
    /bin/ln -s /usr/share/phpMyAdmin-${PHP_MY_ADMIN_VER}-all-languages /usr/share/phpMyAdmin
  fi
fi

#install DSaaS Client
/usr/bin/wget https://app.deepsecurity.trendmicro.com:443/software/agent/amzn1/x86_64/ -O /tmp/agent.rpm --no-check-certificate --quiet
/bin/rpm -ihv /tmp/agent.rpm || /bin/rpm -Uhv /tmp/agent.rpm
/bin/rm -rf /tmp/agent.rpm
