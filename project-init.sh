#!/bin/bash

PROJECT_NAME=$1
LOCAL_DOMAIN=$2
MULTIPLE_DOMAINS=$3
PHP_VERSION=$4
SOURCE_PATH=$5
HOST_IP=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')
CURRENT_DIR=${PWD}


#Enter params
if [ -z "$PROJECT_NAME" ]; then
    read -p "Project name (${CURRENT_DIR##*/} is used if empty): " PROJECT_NAME
fi
if [ -z "$PROJECT_NAME" ]; then
	PROJECT_NAME=${CURRENT_DIR##*/}
fi
if [ -z "$LOCAL_DOMAIN" ]; then
    read -p "Local domain (${CURRENT_DIR##*/}.local is used if empty): " LOCAL_DOMAIN
fi
if [ -z "$LOCAL_DOMAIN" ]; then
    LOCAL_DOMAIN=${CURRENT_DIR##*/}.local
fi
if [ -z "$MULTIPLE_DOMAINS" ]; then
    read -p "Multiple domains for same site (www.${CURRENT_DIR##*/}.local is used if empty, separated by comma): " MULTIPLE_DOMAINS
fi
if [ -z "$MULTIPLE_DOMAINS" ]; then
    MULTIPLE_DOMAINS=www.${CURRENT_DIR##*/}.local
fi
if [ -z "$PHP_VER" ]; then
    read -p "PHP version (7.2 is used if empty): " PHP_VER
fi
if [ -z "$PHP_VER" ]; then
	PHP_VER="7.2"
fi
if [ -z "$SOURCE_PATH" ]; then
    read -p "Source path (${CURRENT_DIR}/html is used if empty): " SOURCE_PATH
fi
if [ -z "$SOURCE_PATH" ]; then
	SOURCE_PATH=${CURRENT_DIR}/html
fi

#Check if source code exists
if [ -d "${SOURCE_PATH}" ]; then
    if [ -d "${SOURCE_PATH}/.git" ]; then
    	if ! [ -f "${SOURCE_PATH}/.git/info/exclude" ]; then
    		mkdir "${SOURCE_PATH}/.git/info" && touch "${SOURCE_PATH}/.git/info/exclude"
    	fi
        if ! grep -Fxq "/.docker-path" "${SOURCE_PATH}/.git/info/exclude"
        then
            echo "/.docker-path" >> "${SOURCE_PATH}/.git/info/exclude"
        fi
    fi
else
    echo "Source does not exists, please clone the source to ${SOURCE_PATH} then try again"
    exit 1;
fi

#Check if current folder exists git
if [ -d "${CURRENT_DIR}/.git" ]; then
    if ! [ -f "${CURRENT_DIR}/.git/info/exclude" ]; then
        mkdir "${CURRENT_DIR}/.git/info" && touch "${CURRENT_DIR}/.git/info/exclude"
    fi
    if ! grep -Fxq "/.docker" "${SOURCE_PATH}/.git/info/exclude"
    then
        echo "/.docker" >> "${SOURCE_PATH}/.git/info/exclude"
    fi
fi

#Check if current folder has .docker, backup it and create new one.
if [ -d ".docker" ]; then
    cd "${CURRENT_DIR}/.docker" && docker-compose down --remove-orphans && docker-compose rm -f
    cd "${CURRENT_DIR}"
    mv "${CURRENT_DIR}/.docker" "${CURRENT_DIR}/.docker_$(date +%s)"
fi

cp -r "${FR_DOCKER}/.template-docker" ".docker"
echo "${CURRENT_DIR}/.docker" > "${CURRENT_DIR}/.docker/.path"
if [ -f "${SOURCE_PATH}/.docker-path" ]; then
    rm "${SOURCE_PATH}/.docker-path"
fi
ln -s "${CURRENT_DIR}/.docker/.path" "${SOURCE_PATH}/.docker-path"
ln -s "${FR_DOCKER_DEFAULT}/docker-compose.yml" ".docker/docker-compose.yml"


#Change ENVs
[ ! -z "${PROJECT_NAME}" ] && sed -i "s#!PROJECT_NAME!#${PROJECT_NAME}#" ".docker/.env"
[ ! -z "${LOCAL_DOMAIN}" ] && sed -i "s#!LOCAL_DOMAIN!#${LOCAL_DOMAIN}#" ".docker/.env"
[ ! -z "${PHP_VER}" ] && sed -i "s#!PHP_VER!#${PHP_VER}#" ".docker/.env"
[ ! -z "${SOURCE_PATH}" ] && sed -i "s#!SOURCE_PATH!#${SOURCE_PATH}#" ".docker/.env"
[ ! -z "${HOST_IP}" ] && sed -i "s#!HOST_IP!#${HOST_IP}#" ".docker/.env"
sed -i "s#!MULTIPLE_DOMAINS!#${MULTIPLE_DOMAINS}#" ".docker/.env"
#Change docker tag version if php
if [ "${PHP_VER}" = "7.1" ]; then
  echo "DOCKER_VER_TAG=1.1" >> ".docker/.env"
fi
#End


#Check if host file line
MULTIPLE_DOMAINS=$(echo "${MULTIPLE_DOMAINS}" | sed "s/,/ /g")
if ! grep -q "${LOCAL_DOMAIN}" /etc/hosts
then
  echo -e "127.0.0.1 $LOCAL_DOMAIN $MULTIPLE_DOMAINS" >> /etc/hosts
fi
for i in "${MULTIPLE_DOMAINS}"; 
do
    if ! grep -q "${i}" /etc/hosts
    then
      echo -e "127.0.0.1 ${i}" >> /etc/hosts
    fi
done