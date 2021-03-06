#!/bin/bash
AMIMOTO_BRANCH='2016.01'

hash jq  || /usr/bin/yum -y install jq

[ ! -e /opt/local ] && mkdir -p /opt/local
[ ! -f /opt/local/amimoto.json ] && echo '{"run_list":["recipe[amimoto]"]}' > /opt/local/amimoto.json
[ "$(cat /opt/local/amimoto.json)" = "" ] && echo '{"run_list":["recipe[amimoto]"]}' > /opt/local/amimoto.json

# node[:hhvm][:enabled] enabled
TMP_JSON=$(mktemp)
/usr/bin/jq -s '.[1] * .[0]' \
  <(echo '{"hhvm":{"enabled":true},"phpfpm":{"version":"72"},"wordpress":{"woocommerce":true}}') \
  /opt/local/amimoto.json \
  > ${TMP_JSON}
[ -f ${TMP_JSON} ] && mv -f ${TMP_JSON} /opt/local/amimoto.json

/usr/bin/curl -L -s https://raw.githubusercontent.com/Launch-with-1-Click/lw1-amimoto/${AMIMOTO_BRANCH}/initial.wp-setup.sh | /bin/bash
