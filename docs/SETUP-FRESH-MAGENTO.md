# CREATE NEW SITE FRESH MAGENTO

## 1. Services
- PhpMyAdmin: https://phpmyadmin.local
- PHP: 7.4 (cli & fpm) [Available PHP Version](https://registry.hub.docker.com/r/magento/magento-cloud-docker-php/tags)
    - Xdebug Port: **9001**
- Nginx: 1.23.2/Apache 2.4
    - [Available Nginx version & document](https://registry.hub.docker.com/r/magento/magento-cloud-docker-nginx/tags)
    - [Available Apache version & document](https://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/php-apache-dev.html)
- MariaDB: **10.4**
- Varnish: **6.2-1.2.2**
- Redis: 3.0 [Available Redis version](https://registry.hub.docker.com/_/redis?tab=tags)
- Mailhog: https://mailhog.local
- Elasticsearch: https://localhost:9200

### Check requirements system and component service support for new site magento
- Read requirements https://devdocs.magento.com/guides/v2.4/install-gde/system-requirements.html


## 2. Create project folder name on structure Docker

- Create new project `<project_name>` is your project folder

    `mkdir -p ~/Sites/<project_name>`
    
    `cd ~/Sites/<project_name>`

Example: `mkdir -p ~/Site/freshmagento/`

- Create new folder `html` structure and copy soure on this path

- Clone source code from github Mangento https://github.com/magento/magento2.git 
    
    `cd ~/Sites/<project_name>`

    `git clone https://github.com/magento/magento2.git html`

Example:

`cd ~/Site/freshmagento/`
     
`git clone https://github.com/magento/magento2.git html`

`git checkout 2.4`

 <2.4 version magento>

structure on folder `~/Site/freshmagento/html`:

    `...
        app
        auth.json.sample
        bin
        CHANGELOG.md
        composer.json
        composer.lock
        COPYING.txt
        dev
        generated
    ...`


## 3. Create Database on Docker MariaDB

- Exec to docker and create database for new fresh magento
  - `docker exec -it mysql /bin/bash`
  - `mysql -uroot -pmysql`
  - `create database <database-name>`

Example:
  - `docker exec -it mysql8 /bin/bash`
  - `mysql -uroot -pmysql`
  - `create database freshmagento_local`

## 4. Setup

- Git clone this project
  `cd ~ && git clone -b master git@bitbucket.org:forix/forix-docker-local-dev.git Docker`
- Setup docker
  `cd ~/Docker && bash docker-setup.sh`

- Add rootCA.pem from ~Docker/.shared-services/certs/rootCA.pem to chrome for SSL verify. Go to chrome -> Settings -> Search "Manage certificates" -> Sercurity -> Manage certificates -> Tag "Authorities" -> Import 


## 5. Starting

- cd project `cd ~/Sites/<project_name>`
  
  - Example: `cd ~/Site/freshmagento/`

- Source to run aliases `source ~/.bash_aliases`

- Then execute `fr-docker-init` and ENTER all information to set up your project
Example:
    - Remember version magento choose version php 7.4
- Install Composer
    - `cd ~/Sites/<project_name>/html`
    - `composer install`

Example: 
  - `cd ~/Site/freshmagento/html`
  - `composer install`

Install Magento follow link install `https://devdocs.magento.com/guides/v2.3/install-gde/composer.html#install-magento`
  - `cd ~/Sites/<project_name>/html`
  - ` php bin/magento setup:install \
      --base-url=https://freshmagento.local/ \
      --db-host=mysql:3306 \
      --db-name=freshmagento_local \
      --db-user=root \
      --db-password=mysql \
      --admin-firstname=admin \
      --admin-lastname=admin \
      --admin-email=admin@admin.com \
      --admin-user=admin \
      --admin-password=admin123 \
      --language=en_US \
      --currency=USD \
      --timezone=America/Chicago \
      --use-rewrites=1 \
      --search-engine=elasticsearch7 \
      --elasticsearch-host=elasticsearch \
      --elasticsearch-port=9200 \
      --elasticsearch-index-prefix=magento2 \
      --elasticsearch-timeout=15`

Enable add Ext Sodium:
- `cd ~/Sites/<project_name>/.docker`
- add comment `EXT_PHP_EXTENSION=sodium` to file `.env`

- Go to your source code dir `cd <project_name/html`

    - **Docker compose command line** `docker-compose --env=../.docker/.env -f ../.docker/docker-compose.yml -f ~/Docker/.default/compose."nginx|nginx.varnish|apache|apache.varnish".yml -f ~/Docker/.shared-services/compose.mkcert.yml -f ../.docker/docker-compose.override.yml  (up|down|restart|stop|start|exec|logs)`
        - _Example:_
            - Up server: `docker-compose --env=../.docker/.env -f ../.docker/docker-compose.yml -f ~/Docker/.default/compose.nginx.yml -f ~/Docker/.shared-services/compose.mkcert.yml -f ../.docker/docker-compose.override.yml up -d`
            - Down server: `docker-compose --env=../.docker/.env -f ../.docker/docker-compose.yml -f ~/Docker/.default/compose.nginx.yml -f ~/Docker/.shared-services/compose.mkcert.yml -f ../.docker/docker-compose.override.yml down`
      
    - **Aliases**  `nginx|nginx.varnish|apache|apache.varnish (up|down|restart|stop|start|exec|logs)`
        - _Example:_
            - Up server: `nginx up -d`
            - Down server: `nginx down`
    
    - **Execute common services**: php, composer, grunt, node
      - Aliases: Execute `php|composer|grunt|node <args>` directly on your source code.
      - Outside container: `nginx exec deploy php|composer|grunt|node <args>`
      - Inside container: `nginx exec deploy bash` then execute your command inside container.