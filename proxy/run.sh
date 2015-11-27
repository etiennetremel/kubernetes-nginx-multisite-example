#!/bin/sh
#
# Startup script, replace all {{VARIABLE}} to correct Service IP/Host
#
set -e

sed -i "s/{{SITE_ONE_SERVICE}}/${SITE_ONE_SERVICE_HOST}:${SITE_ONE_SERVICE_PORT}/g;" /etc/nginx/sites-enabled/site-one.conf
sed -i "s/{{SITE_TWO_SERVICE}}/${SITE_TWO_SERVICE_HOST}:${SITE_TWO_SERVICE_PORT}/g;" /etc/nginx/sites-enabled/site-two.conf

exec "$@"
