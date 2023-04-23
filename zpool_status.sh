#!/bin/bash

# Source the configuration file
source config.sh

current_date=$(date '+%Y-%m-%d')
SUBJECT="ZFS Pool Error Alert ($current_date)"
MESSAGE="An error occurred in a ZFS pool."

# Error handling
script_name=$(basename "$0")
trap 'echo "$(date) - $script_name: An error occurred." >> $ERROR_LOG' ERR

# Function to send email using SendGrid
send_email() {
  
  curl -s -X "POST" "https://api.sendgrid.com/v3/mail/send" \
     -H "Authorization: Bearer $SENDGRID_API_KEY" \
     -H "Content-Type: application/json" \
     -d $'{
    "personalizations": [
      {
        "to": [
          {
            "email": "'"$TO_EMAIL"'",
            "name": "'"$TO_NAME"'"
          }
        ],
        "subject": "'"$SUBJECT"'"
      }
    ],
    "content": [
      {
        "type": "text/plain",
        "value": "'"$MESSAGE"'"
      }
    ],
    "from": {
      "email": "'"$FROM_EMAIL"'",
      "name": "'"$FROM_NAME"'"
    }
  }' 2>&1
}

# Check for errors in ZFS pools
zpool_status=$(zpool status)
error_check=$(echo "$zpool_status" | grep -E "state: (DEGRADED|FAULTED|OFFLINE|UNAVAIL|REMOVED)")

if [ ! -z "$error_check" ]; then
  # Send email using SendGrid, capture error output, and write it to the error logfile
  error_output=$(send_email)
  if [[ ! -z "$error_output" ]]; then
    echo "$(date) - $script_name: $error_output" >> $ERROR_LOG
  fi
fi
