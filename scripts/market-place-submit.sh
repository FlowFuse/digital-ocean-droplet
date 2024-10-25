#!/bin/bash -x

IMAGE_ID=$(jq '.builds[-1].artifact_id | split(":")[1] | tonumber' manifest.json)
# this should come from an app secret, this is new FlowFuse app id
APP_ID=92052e1d7b34519f48b3b269
# This needs to be incremented on each sucessful update. I've asked DO 
# for a way to get the current value via API to make it easier
UPDATE_VERSION=19

cat << EOF > update.json
{
  "reasonForUpdate": "new release",
  "version": "${FF_VERSION}",
  "imageId": "${IMAGE_ID},
  "softwareIncluded": [
    { "name": "FlowFuse", "version": "${FF_VERSION}", "releaseNotes": "https://github.com/FlowFuse/flowfuse/releases/tag/v${FF_VERSION}" },
    { "name": "Ubuntu", "version": "22.04" },
    { "name": "Docker CE", "version": "20.10.21" },
    { "name": "Docker Compose", "version": "2.12.0" }
  ]
}
EOF

cat update.json

echo ${FF_VERSION}

echo https://api.digitalocean.com/api/v1/vendor-portal/apps/${APP_ID}/versions/${UPDATE_VERSION}

curl --fail-with-body -X PATCH -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_API_TOKEN}" \
  -d @update.json  https://api.digitalocean.com/api/v1/vendor-portal/apps/${APP_ID}/versions/${UPDATE_VERSION}

if [ $? -eq 0 ]
then
  rm update.json
else
  echo "Digitial Ocean Market Place update failed"
  exit 1
fi