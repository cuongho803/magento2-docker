FROM golang:alpine

RUN cd /go && \
    go install filippo.io/mkcert@latest

WORKDIR /root/.local/share/mkcert


CMD mkcert -install && DOMAIN_LIST=$(echo $DOMAINS | sed "s/,/ /g") && mkcert -cert-file $FILENAME.crt -key-file $FILENAME.key $DOMAIN_LIST
