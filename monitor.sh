#!/bin/bash

#
# Prerequisties: Needs Azure CLI and jq available on current path.
#

echo "{\"lastupdate\":\"$(date -u +"%FT%T.000+00:00")\"}" | jq -r . > now.json

# Note the '--account-name' parameter below must match what is configured in the deploy.sh file

az storage blob upload \
  -n now.json \
  -c status \
  -f now.json \
  --account-name powermonitor050920211 \
  --only-show-errors \
  --no-progress

