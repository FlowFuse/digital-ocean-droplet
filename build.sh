#!/bin/bash

# expects .env to hold a DIGITALOCEAN_API_TOKEN

# source .env
export DIGITALOCEAN_API_TOKEN
FF_VERSION=`echo $FF_VERSION | sed 's/v//'`
export FF_VERSION
export FF_DASH_VERSION=`echo $FF_VERSION | sed 's/\./-/g'`
echo $FF_VERSION $FF_DASH_VERSION
packer build template.json
