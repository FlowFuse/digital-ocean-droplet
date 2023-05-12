#!/bin/bash

# expects .env to hold a DIGITALOCEAN_API_TOKEN

# source .env
export DIGITALOCEAN_API_TOKEN
export FF_VERSION
export FF_DASH_VERSION=`echo $FF_VERSION | sed 's/\./-/g' | sed 's/v//`
packer build template.json
