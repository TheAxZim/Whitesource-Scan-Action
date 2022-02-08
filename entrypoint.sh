#!/bin/sh -l

set -e

if [ -z "$INPUT_APIKEY" ]; then
  echo "You must set an API key!"
  exit 126
fi

if [ -z "$INPUT_CONFIGFILE" ] && [ -z "$INPUT_PROJECTNAME" ]; then
  echo "'projectName' or 'configFile' path must be set."
  exit 126
fi

PRODUCT_NAME_STR=""
if [ -n "$INPUT_PRODUCTNAME" ]; then
  PRODUCT_NAME_STR="-product $INPUT_PRODUCTNAME"
fi

# Download latest Unified Agent release from Whitesource
curl -LJO  https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar

# Run additional commands if necessary
if [ -n "$INPUT_EXTRACOMMANDSFILE" ]; then
  echo "Executing file: $INPUT_EXTRACOMMANDSFILE"
  chmod +x $INPUT_EXTRACOMMANDSFILE
  ./$INPUT_EXTRACOMMANDSFILE
fi

# verify jar signature
jarsigner -verify  wss-unified-agent.jar

# don't exit if unified agent exits with error code
set +e
# Execute Unified Agent (2 settings)
if [ -z  "$INPUT_CONFIGFILE" ]; then
  java -jar wss-unified-agent.jar -noConfig true -apiKey $INPUT_APIKEY -project "$INPUT_PROJECTNAME" $PRODUCT_NAME_STR\
    -d . -wss.url $INPUT_WSSURL -resolveAllDependencies true
else
  java -jar wss-unified-agent.jar -apiKey $INPUT_APIKEY -c "$INPUT_CONFIGFILE" -d .
fi

WS_EXIT_CODE=$?
echo "WS exit code: $WS_EXIT_CODE"

if [ -n "$WS_USERKEY" ] && [ "$WS_GENERATEPROJECTDETAILSJSON" == "true" ]; then
  /list-project-alerts.sh
fi

exit $WS_EXIT_CODE
