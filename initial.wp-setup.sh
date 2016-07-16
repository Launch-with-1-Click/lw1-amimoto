#!/bin/bash
PHP_MY_ADMIN_VER="4.5.3.1"
AMIMOTO_BRANCH='2016.01'

INSTANCETYPE=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-type)
INSTANCEID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)

SERVERNAME=${INSTANCEID}


## cleanup and initialyze
[ -f /usr/bin/python2.7 ] && \
  /usr/sbin/alternatives --set python /usr/bin/python2.7

hash git || /usr/bin/yum -y install git
hash jq  || /usr/bin/yum -y install jq

/sbin/service monit stop
/sbin/service mysql stop
/sbin/service php-fpm stop
/sbin/service nginx stop
/sbin/service httpd stop
if [ "t1.micro" = "${INSTANCETYPE}" ]; then
  /sbin/chkconfig memcached off
  /sbin/service memcached stop
fi
[ -f /var/run/nginx-backend.sock ] && \
  rm -f /var/run/nginx-backend.sock

/usr/bin/yum clean all

/bin/rm -f  /root/.mysql_history
/bin/rm -f  /root/.bash_history
/bin/rm -f  /home/ec2-user/.bash_history
/bin/rm -rf /var/www/vhosts/i-*
/bin/rm -rf /opt/local/amimoto
/bin/rm -rf /var/log/nginx/*
/bin/rm -rf /var/cache/nginx/*
/bin/rm -rf /var/log/php-fpm/*
/bin/rm -rf /var/log/httpd/*
/bin/rm -f  /var/lib/mysql/ib_logfile*
/bin/rm -f  /var/log/mysqld.log*
/bin/rm -f  /etc/php-fpm.d/www.conf
/bin/rm -f  /etc/nginx/nginx.conf
/bin/rm -f  /etc/nginx/conf.d/default.*
/bin/rm -f  /etc/yum.repos.d/amimoto-nginx-mainline.repo*
/bin/rm -f  /etc/yum.repos.d/opsrock-*.repo*
/bin/rm -f  /etc/yum.repos.d/hop5.repo
/bin/rm -f  /etc/yum.repos.d/remi*.repo*
/bin/rm -f  /etc/yum.repos.d/Percona.repo*
/bin/rm -f  /etc/yum.repos.d/percona-release.repo*
/bin/rm -f  /etc/yum.repos.d/*.rpmsave

[ ! -e /opt/local ] && \
  mkdir -p /opt/local
[ ! -f /opt/local/amimoto.json ] && \
  echo '{"run_list":["recipe[amimoto]"]}' > /opt/local/amimoto.json
[ "$(cat /opt/local/amimoto.json)" = "" ] && \
  echo '{"run_list":["recipe[amimoto]"]}' > /opt/local/amimoto.json

[ ! -d /var/www/vhosts/${SERVERNAME} ] && \
  /bin/mkdir -p /var/www/vhosts/${SERVERNAME}

index_html='<html>
<head><title>Setting up your WordPress now.</title></head>
<body><p>Setting up your WordPress now.</p><p>After a while please reload your web browser.</p></body>
</html>'
echo $index_html > /var/www/vhosts/${SERVERNAME}/index.html
echo $index_html > /var/www/html/index.html


## git pull AMIMOTO cookbook
AMIMOTO_COOKBOOK_PATH='/opt/local/chef-repo/cookbooks/amimoto/'

/usr/bin/git -C ${AMIMOTO_COOKBOOK_PATH} fetch origin || \
  /usr/bin/git -C ${AMIMOTO_COOKBOOK_PATH} fetch mirror
/usr/bin/git -C ${AMIMOTO_COOKBOOK_PATH} checkout ${AMIMOTO_BRANCH}
/usr/bin/git -C ${AMIMOTO_COOKBOOK_PATH} pull origin ${AMIMOTO_BRANCH} || \
  /usr/bin/git -C ${AMIMOTO_COOKBOOK_PATH} pull mirror ${AMIMOTO_BRANCH}


## create provision script
AMIMOTO_JSON='/opt/local/amimoto.json'
[ -f /opt/local/amimoto-managed.json ] && \
  AMIMOTO_JSON='/opt/local/amimoto-managed.json'

chef_solo='/opt/chef/bin/chef-solo'
[ -f /usr/bin/chef-solo ] && \
  chef_solo='/usr/bin/chef-solo'

cat << EOS > /opt/local/provision
#!/bin/bash
/sbin/service monit stop
[ -f /usr/bin/python2.7 ] && /usr/sbin/alternatives --set python /usr/bin/python2.7
/usr/bin/git -C ${AMIMOTO_COOKBOOK_PATH} pull origin ${AMIMOTO_BRANCH}
${chef_solo} -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error
EOS
chmod +x /opt/local/provision

/usr/bin/crontab -r
echo '@reboot /bin/sh /opt/local/provision > /dev/null 2>&1' | crontab


## provision
$chef_solo -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error
[ ! -f /etc/nginx/nginx.conf ] && \
  $chef_solo -o amimoto::nginx -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error
[ ! -f /etc/nginx/conf.d/default.conf ] && \
  $chef_solo -o amimoto::nginx_default -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error
[ ! -f /etc/php-fpm.d/www.conf ] && \
  $chef_solo -o amimoto::php -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error

CF_PATTERN=$(/usr/bin/php /opt/local/cf_patern_check.php)
[ "$CF_PATTERN" = "nfs_server" ] && \
  $chef_solo -o amimoto::nfs_dispatcher -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error
[ "$CF_PATTERN" = "nfs_client" ] && \
  $chef_solo -o amimoto::nfs_dispatcher -c /opt/local/solo.rb -j ${AMIMOTO_JSON} -l error

if [ -f /usr/sbin/getenforce ]; then
  if [ "Enforcing" = "`/usr/sbin/getenforce`" ]; then
    /usr/bin/yum install -y setools-console
    /usr/sbin/semanage fcontext -a -t httpd_sys_content_t "/opt/local/amimoto(/.*)?"
    /sbin/restorecon -R -v /opt/local/amimoto/
  fi
fi


## install default WordPress
if [ "$CF_PATTERN" != "nfs_client" ]; then
  SERVER_JSON="/opt/local/${SERVERNAME}.json"
  TMP_JSON=$(mktemp)

  echo "WordPress install ..."

  cd /opt/local
  /usr/local/bin/wp-setup-json ${SERVERNAME} | /usr/bin/jq '.' > ${SERVER_JSON}
  [ "$(cat ${SERVER_JSON})" = "" ] && \
    echo '{"wordpress":{}}' > ${SERVER_JSON}
  chmod 0600 $SERVER_JSON
  /bin/cp -f $SERVER_JSON $TMP_JSON
  [ -f ${AMIMOTO_JSON} ] && \
    /usr/bin/jq -s '.[0] * .[1]' ${SERVER_JSON} ${AMIMOTO_JSON} > ${TMP_JSON}

  $chef_solo -o amimoto::wordpress -c /opt/local/solo.rb -j ${TMP_JSON} -l error

  /bin/rm -f ${TMP_JSON}
  [ -f /var/www/vhosts/${SERVERNAME}/wp-content/object-cache.php ] && \
    /bin/rm -f /var/www/vhosts/${SERVERNAME}/wp-content/object-cache.php

  echo "... WordPress installed"
fi

[ -f /var/www/html/index.html ] && \
  /bin/rm -f /var/www/html/index.html
[ -f /var/www/vhosts/${SERVERNAME}/index.html ] && \
  /bin/rm -f /var/www/vhosts/${SERVERNAME}/index.html

/bin/chown -R nginx:nginx /var/log/nginx
/bin/chown -R nginx:nginx /var/log/php-fpm
/bin/chown -R nginx:nginx /var/tmp/php
/bin/chown -R nginx:nginx /var/lib/php
/bin/chmod +x /usr/local/bin/wp-setup


## install DSaaS Client
/usr/bin/wget https://app.deepsecurity.trendmicro.com:443/software/agent/amzn1/x86_64/ -O /tmp/agent.rpm --no-check-certificate --quiet
/bin/rpm -ihv /tmp/agent.rpm || /bin/rpm -Uhv /tmp/agent.rpm
/bin/rm -rf /tmp/agent.rpm
