#!/bin/bash

release_metadata=$(curl -s https://api.github.com/repos/actions/runner/releases/latest)
latest_release_date=$(date -d "$(echo "$release_metadata" | jq -r '.published_at')" '+%s')
latest_release_date_formatted=$(date -d "@$latest_release_date" '+%Y-%m-%d')
echo "latest_release_date (Y-M-D): $latest_release_date_formatted"

current_date=$(date '+%s')
current_date_formatted=$(date -d "@$current_date" '+%Y-%m-%d')
echo "current_date (Y-M-D): $current_date_formatted"

date_diff=$(( (current_date - latest_release_date) / 86400 ))  # Calculate the difference in days

echo "date_diff: $date_diff"

if [ "$date_diff" -ge 0 ]; then
  echo "The latest version is $date_diff days old compared to the current date."
else
  echo "The latest version is from the future."
fi
