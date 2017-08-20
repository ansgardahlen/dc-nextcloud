#!/bin/bash

if [[ -f nextcloud.conf ]]; then
  read -r -p "config file nextcloud.conf exists and will be overwritten, are you sure you want to contine? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      mv nextcloud.conf nextcloud.conf_backup
      ;;
    *)
      exit 1
    ;;
  esac
fi

if [ -z "$NEXTCLOUD_HOSTNAME" ]; then
  read -p "Hostname (FQDN): " -ei "nextcloud.example.org" NEXTCLOUD_HOSTNAME
fi

if [ -z "$NEXTCLOUD_ADMIN_MAIL" ]; then
  read -p "Nextcloud admin Mail address: " -ei "mail@example.com" NEXTCLOUD_ADMIN_MAIL
fi

[[ -f /etc/timezone ]] && TZ=$(cat /etc/timezone)
if [ -z "$TZ" ]; then
  read -p "Timezone: " -ei "Europe/Berlin" TZ
fi


DBNAME=nextcloud
DBUSER=nextcloud
DBPASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

HTTP_PORT=8888


cat << EOF > nextcloud.conf
# ------------------------------
# nextcloud web ui configuration
# ------------------------------
# example.org is _not_ a valid hostname, use a fqdn here.
NEXTCLOUD_HOSTNAME=${NEXTCLOUD_HOSTNAME}

# ------------------------------
# NEXTCLOUD admin user
# ------------------------------
NEXTCLOUD_ADMIN=nextcloudadmin
NEXTCLOUD_ADMIN_MAIL=${NEXTCLOUD_ADMIN_MAIL}
NEXTCLOUD_PASS=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

# ------------------------------
# SQL database configuration
# ------------------------------
DBNAME=${DBNAME}
DBUSER=${DBUSER}

# Please use long, random alphanumeric strings (A-Za-z0-9)
DBPASS=${DBPASS}
DBROOT=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 28)

# ------------------------------
# Bindings
# ------------------------------

# You should use HTTPS, but in case of SSL offloaded reverse proxies:
HTTP_PORT=${HTTP_PORT}
HTTP_BIND=0.0.0.0

# Your timezone
TZ=${TZ}

# Fixed project name
COMPOSE_PROJECT_NAME=nextcloud

EOF

