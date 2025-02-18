#!/bin/bash
set -oue pipefail

# Check if the flag exists. If we've already deleted, then we've already ran.
if [ ! -f /etc/post_update/post_update.flag ]; then
    exit 0
fi

./tmp/build/flatpaks.sh

# Delete the flag. 
rm -f /etc/post_update/post_update.flag 

exit 0