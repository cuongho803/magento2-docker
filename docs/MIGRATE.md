## Migrate Source Branch Master to Branch Project forix-docker-local-dev


### 1. Export database from old project

- Export database
  - `docker exec mysql /usr/bin/mysqldump -uroot -pmysql {database} > backup.sql`

Example: docker exec mysql /usr/bin/mysqldump -uroot -pmysql forixweb_local > backup.sql


### 2. Create project folder name on structure Docker

- Create new project `<project_name>` is your project folder

    `mkdir -p ~/Sites/<project_name>`
    
    `cd ~/Sites/<project_name>`

Example: `mkdir -p ~/Site/forixweb/`

- Create new folder `html` structure and copy soure on this path

    `mkdir -p ~/Sites/<project_name>/html`

- copy all source to this path `mkdir -p ~/Sites/<project_name>/html/*`

Example: 

`mkdir -p ~/Site/forixweb/html`
     
`cp -rv source/* ~/Site/forixweb/html`

### 3. Setup Docker

- Git clone this project
  `cd ~ && git clone -b master git@bitbucket.org:forix/forix-docker-local-dev.git Docker`
- Setup docker
  `cd ~/Docker && bash docker-setup.sh`

- Add rootCA.pem from ~Docker/.shared-services/certs/rootCA.pem to chrome for SSL verify. Go to chrome -> Settings -> Search "Manage certificates" -> Sercurity -> Manage certificates -> Tag "Authorities" -> Import 

### 4. Starting

- cd project `cd ~/Sites/<project_name>`
  
  - Example: cd ~/Site/forixweb/

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

### 5. Import database

- Import database old project 

`cat file.sql | docker exec -i mysql /usr/bin/mysql -u root -pmysql {database}`

Example: `cat file.sql | docker exec -i mysql /usr/bin/mysql -u root -pmysql forixweb_local`

Note: 
- create first database if not exists and import
- import issue error `ERROR 1273 (HY000) at line 10821: Unknown collation: 'utf8mb4_0900_ai_ci`
  - `sed -i 's/utf8mb4_0900_ai_ci/utf8_general_ci/g' backup.sql`  
     `sed -i 's/CHARSET=utf8mb4/CHARSET=utf8/g' backup.sql`  