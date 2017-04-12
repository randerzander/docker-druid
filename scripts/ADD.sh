#!/bin/bash
set -eu

TARGET=$1

# Load list of URLs/Subfolders
source /scripts/env.sh

# Get URL for specified artifact
declare URL="${TARGET}_URL"
TARGET_URL=${!URL}
# Get Subfolder for specified artifact
declare SUBFOLDER="${TARGET}_SUBFOLDER"
TARGET_SUBFOLDER=${!SUBFOLDER}

# Download and decompress artifact
TARGET_FILE="/tmp/${TARGET_URL##*/}"
wget --directory-prefix /tmp $TARGET_URL
if [[ $TARGET_FILE =~ \.t?gz$ ]]; then
  tar -xzvf $TARGET_FILE
fi

# Move artifact to standard folder name
mv $TARGET_SUBFOLDER ${TARGET,,}
