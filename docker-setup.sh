#!/bin/bash

CURRENTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git pull origin master

#Change docker folder path and attach aliases
sed '/forix_bash_aliases/d;/FR_DOCKER/d' -i ~/.bash_aliases
echo "export FR_DOCKER=$CURRENTDIR" >> ~/.bash_aliases
echo "source $CURRENTDIR/.forix_bash_aliases" >> ~/.bash_aliases

#Update host file for mailhog and phpmyadmin
HOSTLINE="127.0.0.1 mailhog.local phpmyadmin.local"
if ! grep -Fxq "${HOSTLINE}" /etc/hosts
then
  echo -e "$HOSTLINE" >> /etc/hosts
fi

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

cd .shared-services && docker-compose up --build -d && docker-compose rm -f && cd $CURRENTDIR