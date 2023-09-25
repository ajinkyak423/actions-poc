#!/bin/bash

release_metadata=$(curl -s https://api.github.com/repos/actions/runner/releases/latest)
latest_release_date=$(date -d "$(echo "$release_metadata" | jq -r '.published_at')" '+%s')
current_date=$(date '+%s')

date_diff=$(( (latest_release_date - current_date) / 86400 ))  # Calculate the difference in days

echo "date_diff : $date_diff"

expected_date_diff=30

if [ "$date_diff" -ge "$expected_date_diff" ]; then
  echo "The difference between release date and current date is more than 30 days."
else
  echo "The difference between release date and current date is not more than 30 days."
fi