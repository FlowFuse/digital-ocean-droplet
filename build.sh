#!/bin/sh

# expects .env to hold a DIGITALOCEAN_API_TOKEN

. .env
packer build template.json