#!/bin/bash
AMIMOTO_BRANCH='2016.01.initial-script'

hash jq  || /usr/bin/yum -y install jq

[ ! -e /opt/local ] && mkdir -p /opt/local
[ ! -f /opt/local/amimoto.json ] && echo '{"run_list":["recipe[amimoto]"]}' > /opt/local/amimoto.json

# node[:hhvm][:enabled] enabled
/usr/bin/jq -s '.[0] * .[1]' \
  <(echo '{"hhvm":{"enabled":true}}') \
  <(cat /opt/local/amimoto.json) \
  > /opt/local/amimoto.json

/usr/bin/curl -L -s https://raw.githubusercontent.com/Launch-with-1-Click/lw1-amimoto/${AMIMOTO_BRANCH}/initial.wp-setup.sh | /bin/bash