#!/bin/bash

# Include the config file
source config.sh

# Going to the repo folder
cd "${repo}"

# Check if we have new en-US strings from yesterday
locales_mention=`git whatchanged --since="yesterday" | grep en-US`

if [ "$locales_mention" == "" ]; then
  echo "nothing"
else
  tx push -s
fi
