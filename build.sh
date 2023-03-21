#!/bin/bash

# expects .env to hold a DIGITALOCEAN_API_TOKEN

# source .env
export DIGITALOCEAN_API_TOKEN
export FF_VERSION
packer build template.json
