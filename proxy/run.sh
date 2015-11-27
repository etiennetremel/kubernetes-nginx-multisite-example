#!/bin/bash
#
# Startup script, replace all {{VARIABLE}} to correct Service IP/Host

set -e

# Make sure NGINX is not breaking because service is not available
default_service_port="8080"
default_service_host="127.0.0.1"
configuration_files="/etc/nginx/sites-enabled/*.conf"

for file in $configuration_files
do
  placeholder_array=$(grep -Eo "(\{\{[A-Z_]+_SERVICE\}\})" $file)

  for placeholder in $placeholder_array
  do
    service_name=$(echo "$placeholder" | sed -n 's/{{\([A-Z_]*\)_SERVICE}}/\1/p')

    host="${service_name}_SERVICE_HOST"
    port="${service_name}_SERVICE_PORT"

		# Check if environment variable is available, otherwise set default
    if [ -z ${!host} ]; then
      service_host=$default_service_host
    else
      service_host=${!host}
    fi

    if [ -z ${!port} ]; then
      service_port=$default_service_port
    else
      service_port=${!port}
    fi

    # Search and replace service variable in upstream with correct Host IP/Port
    sed -i "s/${placeholder}/${service_host}:${service_port}/g;" $file
  done
done

exec "$@"
