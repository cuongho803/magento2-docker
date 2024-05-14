Update file `docker-compose.override.yml` on `Sites/<project>/.docker/` - ex sample file 

We checked and trick file 000-ioncube.ini need to call path `/usr/local/lib/php/extensions/ioncube.so` inside docker
`'${FR_DOCKER_PROJECT}/php/ioncube.ini:/usr/local/etc/php/conf.d/000-ioncube.ini'`

Create file `ioncube.ini` on `Sites/<project>/.docker/php` with extend path - ex sample file
