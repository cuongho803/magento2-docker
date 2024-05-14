## FORIX DOCKER

### 1. Services

- PhpMyAdmin: https://phpmyadmin.local
- PHP: 7.2 (cli & fpm) [Available PHP Version](https://registry.hub.docker.com/r/magento/magento-cloud-docker-php/tags)
    - Xdebug Port: **9001**
- Nginx: 1.19/Apache 2.4
    - [Available Nginx version & document](https://registry.hub.docker.com/r/magento/magento-cloud-docker-nginx/tags)
    - [Available Apache version & document](https://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/php-apache-dev.html)
- MariaDB: **10**
- Varnish: **6.2-1.2.2**
- Redis: 3.0 [Available Redis version](https://registry.hub.docker.com/_/redis?tab=tags)
- Mailhog: https://mailhog.local
- Elasticsearch: https://localhost:9200

### 2. Setup

- Git clone this project
  `cd ~ && git clone -b master git@bitbucket.org:forix/forix-docker-local-dev.git Docker`
- Setup docker
  `cd ~/Docker && bash docker-setup.sh`


- Add rootCA.pem from ~Docker/.shared-services/certs/rootCA.pem to chrome for SSL verify. Go to chrome -> Settings -> Search "Manage certificates" -> Sercurity -> Manage certificates -> Tag "Authorities" -> Import 



**NOTE:** 
- Run one time and re-run when you move `Docker` to another place.
- This setup will down/remove all your current containers

### 3. Starting:

- Create new project `<project_name>` is your project folder

    `mkdir -p ~/Sites/<project_name>`
    
    `cd ~/Sites/<project_name>`
    
    `git clone <repository_url./html`


- Or existed project `cd ~/Sites/<project_name>`

- Source to run aliases `source ~/.bash_aliases`

- Then execute `fr-docker-init` and ENTER all information to set up your project


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
    
### 4. Import database

- Option 1
  - Download the Production/Staging's database file <mysql_file.sql>.
  - Replace the base URL:
  - `sed -i 's/<production|staging base_url>/<Local domain>/g' <mysql_file.sql>`
  - Copy it to `Docker/.shared-services/dump`
  - Login to the mysql: `docker exec -it mysql mysql -uroot -pmysql`
  - Select the project database: `use <sample_local>;`
  - Import the database: `source /dump/<mysql_file.sql>`

- Option 2:
  - `cat file.sql | docker exec -i mysql /usr/bin/mysql -u root -pmysql {database}`

- Export database
  - `docker exec mysql /usr/bin/mysqldump -uroot -pmysql {database} > backup.sql`

- Aliases:
  - Access: `mysql -uroot -pmysql`
  - Import: `cat file.sql | mysqlimport -uroot -pmysql {database}`
  - Export: `mysqldump -root -pmysql {database} > backup.sql`