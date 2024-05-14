#!/bin/bash
echo "magento-cloud CLI running on container"

if [ ! -f "/root/.ssh/config" ]; then
  mkdir /root/.ssh/ && \
  chmod -R 600 /root/.ssh/config
fi
MAGENTOPATH=$HOME/.magento-cloud/bin
if [ ! -d "$MAGENTOPATH" ]; then
  curl -sS https://accounts.magento.cloud/cli/installer | php
fi
export PATH=$PATH:$HOME/.magento-cloud/bin


if [ ! -z "$1" ]; then
    exec magento-cloud "$@"
else
    exec magento-cloud list
fi