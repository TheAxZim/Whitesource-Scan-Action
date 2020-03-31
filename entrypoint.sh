#!/bin/sh -l

set -e

if [ -z "$INPUT_APIKEY" ]; then
  echo "You must set an API key!"
  exit 126
fi

if [ -z "$INPUT_PROJECTNAME" ]; then
  echo "Project Name must be set."
  exit 126
fi

PRODUCT_NAME=""
if [ -z "$INPUT_PRODUCTNAME" ]; then
  PRODUCT_NAME=$GITHUB_ACTOR
else
  PRODUCT_NAME=$INPUT_PRODUCTNAME
fi

echo "WSS Url: $INPUT_WSSURL"
echo "API Key: $INPUT_APIKEY"
echo "Product Name: $INPUT_PRODUCTNAME"
echo "Project Name: $INPUT_PROJECTNAME"

curl -LJO  https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar

java -jar wss-unified-agent.jar -noConfig true -apiKey $INPUT_APIKEY -project "$INPUT_PROJECTNAME" -product "$PRODUCT_NAME" \
  -d . -wss.url $INPUT_WSSURL -generateScanReport true -resolveAllDependencies true
