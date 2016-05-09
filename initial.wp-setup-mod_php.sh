#!/bin/sh
function plugin_install(){
  cd /tmp

  if [ -f /tmp/${1}.zip ]; then
    rm -r /tmp/${1}.zip
  fi
  /usr/bin/wget http://downloads.wordpress.org/plugin/${1}.zip

  if [ -d /var/www/vhosts/${2}/wp-content/plugins/${1} ]; then
    /bin/rm -rf /var/www/vhosts/${2}/wp-content/plugins/${1}
  fi
  /usr/bin/unzip /tmp/${1}.zip -d /var/www/vhosts/${2}/wp-content/plugins/

  /bin/rm -r /tmp/${1}.zip
}

WP_VER="4.5.2"
PHP_MY_ADMIN_VER="4.5.3.1"
AMIMOTO_BRANCH='2016.01'

INSTANCETYPE=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-type`
INSTANCEID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
AZ=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/`

SERVERNAME=$INSTANCEID

/sbin/service monit stop
/sbin/service mysql stop

/bin/cp /dev/null /root/.mysql_history > /dev/null 2>&1
/bin/cp /dev/null /root/.bash_history > /dev/null 2>&1
/bin/cp /dev/null /home/ec2-user/.bash_history > /dev/null 2>&1
/bin/rm -rf /var/www/vhosts/i-* > /dev/null 2>&1
/bin/rm -rf /opt/local/amimoto > /dev/null 2>&1
/usr/bin/yes | /usr/bin/crontab -r
echo '@reboot /bin/sh /opt/local/provision > /dev/null 2>&1' | crontab

if [ ! -d /var/www/vhosts/${INSTANCEID} ]; then
  /bin/mkdir -p /var/www/vhosts/${INSTANCEID}
fi
echo '<html>
<head>
<title>Setting up your WordPress now.</title>
</head>
 <body>
<p>Setting up your WordPress now.</p>
<p>After a while please reload your web browser.</p>
</body>' > /var/www/vhosts/${INSTANCEID}/index.html

if [ -f /etc/php-fpm.d/www.conf ]; then
  /bin/rm -f /etc/php-fpm.d/www.conf
fi
if [ -f /etc/nginx/nginx.conf ]; then
  /bin/rm -f /etc/nginx/nginx.conf
fi
if [ -f /etc/nginx/conf.d/default.conf ]; then
  /bin/rm -f /etc/nginx/conf.d/default.conf
fi
if [ -f /etc/nginx/conf.d/default.backend.conf ]; then
  /bin/rm -f /etc/nginx/conf.d/default.backend.conf
fi

if [ -f /etc/httpd/conf/httpd.conf ]; then
  /bin/rm -f /etc/httpd/conf/httpd.conf
fi
if [ -f /etc/httpd/conf.d/wordpress.conf ]; then
  /bin/rm -f /etc/httpd/conf.d/wordpress.conf
  /bin/rm -f /etc/httpd/conf.d/install_check.conf
  /bin/rm -f /etc/httpd/conf.d/mod_remoteip.conf
fi

# /usr/bin/git -C /opt/local/chef-repo/ pull origin master
/usr/bin/git -C /opt/local/chef-repo/cookbooks/amimoto/ pull origin ${AMIMOTO_BRANCH} || \
  /usr/bin/git -C /opt/local/chef-repo/cookbooks/amimoto/ pull mirror ${AMIMOTO_BRANCH}
if [ ! -f /etc/httpd/conf/httpd.conf ]; then
  /usr/bin/chef-solo -o amimoto::httpd_default -c /opt/local/solo.rb -j /opt/local/amimoto.json
  /usr/bin/chef-solo -o amimoto::mod_php7 -c /opt/local/solo.rb -j /opt/local/amimoto.json
  /usr/bin/chef-solo -o amimoto::httpd -c /opt/local/solo.rb -j /opt/local/amimoto.json
fi
/usr/bin/chef-solo -c /opt/local/solo.rb -j /opt/local/amimoto.json
if [ ! -f /etc/nginx/nginx.conf ]; then
  /usr/bin/chef-solo -o amimoto::nginx -c /opt/local/solo.rb -j /opt/local/amimoto.json
fi
if [ ! -f /etc/nginx/conf.d/default.conf ]; then
  /usr/bin/chef-solo -o amimoto::nginx_default -c /opt/local/solo.rb -j /opt/local/amimoto.json
fi
/usr/sbin/update-motd

cd /tmp
/usr/bin/git clone git://github.com/megumiteam/amimoto.git || /usr/bin/git clone http://repos.amimoto-ami.com/amimoto.git

#CF_PATTERN=`/usr/bin/curl -s https://raw.githubusercontent.com/megumiteam/amimoto/master/cf_patern_check.php | /usr/bin/php`
CF_PATTERN=`/usr/bin/php /tmp/amimoto/cf_patern_check.php`
if [ "$CF_PATTERN" = "nfs_server" ]; then
  /usr/bin/chef-solo -o amimoto::nfs_dispatcher -c /opt/local/solo.rb -j /opt/local/amimoto.json
fi
if [ "$CF_PATTERN" = "nfs_client" ]; then
  /usr/bin/chef-solo -o amimoto::nfs_dispatcher -c /opt/local/solo.rb -j /opt/local/amimoto.json
fi

if [ ! -d /opt/local/amimoto/wp-admin ]; then
  /bin/mkdir -p /opt/local/amimoto/wp-admin
fi
if [ ! -f /opt/local/amimoto/wp-admin/install.php ]; then
  /bin/cp /tmp/amimoto/install.php /opt/local/amimoto/wp-admin
fi
/bin/chown -R nginx:nginx /opt/local/amimoto
if [ -f /usr/sbin/getenforce ]; then
  if [ "Enforcing" = "`/usr/sbin/getenforce`" ]; then
    /usr/bin/yum install -y setools-console
    /usr/sbin/semanage fcontext -a -t httpd_sys_content_t "/opt/local/amimoto(/.*)?"
    /sbin/restorecon -R -v /opt/local/amimoto/
  fi
fi

/sbin/service monit stop

/sbin/service nginx stop
/bin/rm -Rf /var/log/nginx/*
/bin/rm -Rf /var/cache/nginx/*
/sbin/service nginx start

/sbin/service mysql stop
/bin/rm /var/lib/mysql/ib_logfile*
/bin/rm /var/log/mysqld.log*
/sbin/service mysql start

/sbin/service monit start

WP_CLI=/usr/local/bin/wp
cd /usr/local/bin
/usr/bin/curl -fO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [ -f wp-cli.phar ] ; then
  mv -f wp-cli.phar /usr/local/bin/wp
  chmod +x /usr/local/bin/wp
fi

if [ "$CF_PATTERN" != "nfs_client" ]; then
  echo "WordPress install ..."
  cd /var/www/vhosts/$SERVERNAME
  $WP_CLI core download --version=$WP_VER --allow-root --force
  if [ -f /tmp/amimoto/wp-setup.php ]; then
    /usr/bin/php /tmp/amimoto/wp-setup.php $SERVERNAME $INSTANCEID $PUBLICNAME
  fi

  # Performance
  plugin_install "nginx-champuru" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "wpbooster-cdn-client" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "nephila-clavata" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "c3-cloudfront-clear-cache" "$SERVERNAME" > /dev/null 2>&1

  # Developer
  plugin_install "debug-bar" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "debug-bar-extender" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "debug-bar-console" "$SERVERNAME" > /dev/null 2>&1

  #Security
  #plugin_install "crazy-bone" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "login-lockdown" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "rublon" "$SERVERNAME" > /dev/null 2>&1

  #Other
  plugin_install "nginx-mobile-theme" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "flamingo" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "contact-form-7" "$SERVERNAME" > /dev/null 2>&1
  plugin_install "simple-ga-ranking" "$SERVERNAME" > /dev/null 2>&1

  if [ -f /var/www/vhosts/${INSTANCEID}/wp-content/object-cache.php ]; then
    /bin/rm /var/www/vhosts/${INSTANCEID}/wp-content/object-cache.php
  fi
  if [ -f /etc/redis.conf ]; then
    plugin_install "wp-redis" "$SERVERNAME" > /dev/null 2>&1
    /bin/cp -p /var/www/vhosts/${INSTANCEID}/wp-content/plugins/wp-redis/object-cache.php /var/www/vhosts/${INSTANCEID}/wp-content/
  fi

  echo "... WordPress installed"

  MU_PLUGINS="/var/www/vhosts/${INSTANCEID}/wp-content/mu-plugins"
  if [ ! -d ${MU_PLUGINS} ]; then
    /bin/mkdir -p ${MU_PLUGINS}
  fi
  if [ -d /tmp/amimoto/mu-plugins ]; then
    /bin/cp -rf /tmp/amimoto/mu-plugins/* $MU_PLUGINS
  fi
  if [ -f /tmp/amimoto/cf_option_check.php ]; then
    CF_OPTION=`/usr/bin/php /tmp/amimoto/cf_option_check.php`
    if [ "$CF_OPTION" = "cloudfront" ]; then
      /bin/cp -rf /tmp/amimoto/options/mu-plugins/* $MU_PLUGINS
    fi
  fi

  /bin/rm /var/www/vhosts/${INSTANCEID}/index.html
  /bin/chown -R nginx:nginx /var/cache/nginx
  /bin/chown -R nginx:nginx /var/www/vhosts/$SERVERNAME
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

/bin/rm -rf /tmp/amimoto
