#!/bin/bash

set -e

PROJECT_ID="$(terraform output project_id)"
LOCATION="$(terraform output location)"
KEY_RING_NAME="$(terraform output key_ring_name)"
CRYPTO_KEY_NAME="$(terraform output crypto_key_name)"

if [ "$(uname)" == "Darwin" ]; then
  # macOS
  BASE64_COMMAND="base64 -b 0"
else
  # Linux
  BASE64_COMMAND="base64 -w 0"
fi

echo -n $1 | gcloud kms encrypt \
  --project $PROJECT_ID \
  --location $LOCATION \
  --keyring $KEY_RING_NAME \
  --key $CRYPTO_KEY_NAME \
  --plaintext-file - \
  --ciphertext-file - \
  | $BASE64_COMMAND
