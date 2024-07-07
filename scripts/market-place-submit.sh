#!/bin/bash -x

IMAGE_ID=$(jq '.builds[-1].artifact_id | split(":")[1] | tonumber' manifest.json)
# this should come from an app secret, this is new FlowFuse app id
APP_ID=92052e1d7b34519f48b3b269

curl -X PATCH -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_API_TOKEN}" \
  -d "{\"reasonForUpdate\": \"new release\", \"version\": \"${FF_VERSION}\", \"imageId\": ${$IMAGE_ID}}" https://api.digitalocean.com/api/v1/vendor-portal/apps/${APP_ID}/versions/${APP_VERSION}
