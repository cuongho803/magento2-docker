Example: Start docker-compose other nodejs service update-ca-certificates


- Add .env

```
SHARED_SERVICES=wp.local php.local -> wp.local, php.local is a domain wanna to connect 
COMPOSE_FILE=docker-compose.override.yml:/home/forixsa-thongvo/Docker/.shared-services/compose.mkcert.yml
```

- Start service

```
docker-compose --env-file=.env -f docker-compose.override.yml up -d
Recreating nodejs_node_1 ... done
Creating nodejs_mkcert_1 ... done
```

- Update cert-certification

1. Edit file docker-compose.override.yml

```
    volumes:
      - '../html:/app'
      - '${FR_DOCKER_SHARED}/certs/rootCA.pem:/usr/local/share/ca-certificates/rootCA.crt'
```

```
docker-compose --env-file=.env -f docker-compose.override.yml  exec node update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
```

- Exec to container call https domain local

```
curl https://wp.local
```

