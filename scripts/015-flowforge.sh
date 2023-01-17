#!/bin/sh

mkdir -p /opt/flowforge
curl -L https://github.com/flowforge/docker-compose/archive/refs/tags/${application_version}.tar.gz | tar zx --one-top-level=/opt/flowforge --strip-components=1
docker pull flowforge/node-red
docker pull flowforge/forge-docker
docker pull flowforge/file-server
docker pull iegomez/mosquitto-go-auth
docker pull postgres:14
docker pull nginxproxy/nginx-proxy
docker pull nginxproxy/acme-companion
