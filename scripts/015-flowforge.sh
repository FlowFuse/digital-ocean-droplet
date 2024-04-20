#!/bin/sh

mkdir -p /opt/flowforge
curl -L https://github.com/FlowFuse/docker-compose/archive/refs/tags/v${application_version}.tar.gz | tar zx --one-top-level=/opt/flowforge --strip-components=1
docker pull flowfuse/node-red
docker pull flowfuse/forge-docker
docker pull flowfuse/file-server
docker pull iegomez/mosquitto-go-auth
docker pull postgres:14
docker pull nginxproxy/nginx-proxy
docker pull nginxproxy/acme-companion
