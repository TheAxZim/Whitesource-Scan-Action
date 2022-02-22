#!/bin/bash

set -e

if [ -z "$INPUT_WSSURL" ]; then
  echo "You must set WS base URL!"
  exit 126
fi

if [ -z "$INPUT_APIKEY" ]; then
  echo "You must set an API key!"
  exit 126
fi

PROJECT_NAME_STR=""
if [ -z "$INPUT_PROJECTNAME" ]; then
  IFS='/' read -a GH_REPO <<< "$GITHUB_REPOSITORY"
  PROJECT_NAME_STR="${GH_REPO[1]}"
else
  PROJECT_NAME_STR="$INPUT_PROJECTNAME"
fi

if [ -z "$INPUT_CONFIGFILE" ] && [ -z "$PROJECT_NAME_STR" ]; then
  echo "'projectName' or 'configFile' path must be set."
  exit 126
fi

PRODUCT_NAME_STR=""
if [ -n "$INPUT_PRODUCTNAME" ]; then
  PRODUCT_NAME_STR="-product $INPUT_PRODUCTNAME"
fi

if [ "$INPUT_FAILBUILDONPOLICYVIOLATIONS" == "true" ]; then
  WS_CHECKPOLICIES=true
  WS_FORCECHECKALLDEPENDENCIES=true
  WS_FORCEUPDATE=true
  WS_FORCEUPDATE_FAILBUILDONPOLICYVIOLATION=true
fi

# Download latest Unified Agent release from Whitesource
curl -LJO  https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar

# verify jar signature
jarsigner -verify  wss-unified-agent.jar

# Run additional commands if necessary
if [ -n "$INPUT_EXTRACOMMANDSFILE" ]; then
  echo "Executing file: $INPUT_EXTRACOMMANDSFILE"
  chmod +x $INPUT_EXTRACOMMANDSFILE
  ./$INPUT_EXTRACOMMANDSFILE
fi

#unset GOROOT passed automatically by setup-go
unset GOROOT

# don't exit if unified agent exits with error code
set +e
# Execute Unified Agent (2 settings)
if [ -z  "$INPUT_CONFIGFILE" ]; then
  java -jar wss-unified-agent.jar -noConfig true -apiKey $INPUT_APIKEY -project "$PROJECT_NAME_STR" $PRODUCT_NAME_STR\
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
