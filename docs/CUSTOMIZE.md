## Customize containers

### 1. Modify .env

    COMPOSE_PROJECT_NAME=project_name
    MAIN_DOMAIN=project_name.local
    MULTIPLE_DOMAINS=www.project_name.local
    PHP_VER=7.2
    SOURCE_PATH=/home/phontran/Sites/M2/project_name/html
    HOST_IP=172.17.0.1
    DOCUMENT_ROOT=/app/pub
    APACHE_VER=2.4.46
    NGINX_VER=1.19
    VARNISH_VER=6.2
    UPLOAD_MAX_FILESIZE=128M
    PHP_MEMORY_LIMIT=4G
    MAGENTO_RUN_MODE=developer
    ENABLE_SENDMAIL=true
    SHARED_SERVICES=mysql redis elasticsearch
    EXT_PHP_EXTENSION=sodium mcrypt ioncube
    PAGESPEED=off

- **Pay attention:** 

  - **EXT_PHP_EXTENSION**: Add/remove more php extension.
    
    **Example**: EXT_PHP_EXTENSION=sodium

    - mcrypt is need for php 7.1
    - sodium is need for M2.4
    - ioncude is optional
    
  - **SHARED_SERVICES**:  If you want to change/replace any shared services. Just need to remove it from ENV
    
    **Example**: SHARED_SERVICES=redis elasticsearch

### 2. Modify docker-compose.override.yml

If you want to replace any services, only need to define it on docker-compose.override.yml
  
**Example,** we want to use mysql 8 on new project instead of mariadb

    version: '2.2'
    services:
      generic:
      mysql:
        restart: always
        image: 'mysql:8.0.22'
        ports:
          - '3333:3306'
        volumes:
          - './mysql/stored:/var/lib/mysql'
        environment:
          - MYSQL_ROOT_PASSWORD=mysql

Same as with redis and elasticsearch

### 3. Customize php config, apache, nginx vhost and setup multiple sites.

- following files:

  - .docker/php/php.ini
  - .docker/php/php-fpm.conf
  - .docker/php/multisites.php
  - .docker/apache/custom.conf
  - .docker/nginx/custom.conf

### NOTE: When change these files, you need to down/up your project.