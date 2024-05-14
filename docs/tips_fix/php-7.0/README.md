Docker to support versions above 7.3
If you use version 7.0:
- Remove "DOCKER_VER_TAG:" on path "~/Docker/.default/docker-compose.yml"
  fpm:
    image: 'magento/magento-cloud-docker-php:${PHP_VER:-7.2}-fpm'
  fpm_xdebug:
    image: 'magento/magento-cloud-docker-php:${PHP_VER:-7.2}-fpm'
  deploy:
    image: 'magento/magento-cloud-docker-php:${PHP_VER:-7.2}-cli'