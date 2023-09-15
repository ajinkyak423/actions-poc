#!/bin/bash

yaml_file="$GITHUB_WORKSPACE/kustomization.yml"
echo $yaml_file

latest_release=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')
echo "latest_release=$latest_release" >>$GITHUB_ENV
echo "latest_release=$latest_release"

latest_release_date=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.published_at')
echo "latest_release_date=$latest_release_date" >> $GITHUB_ENV
# echo "latest_release_date=$latest_release_date"

previous_major_version=$(echo $latest_release | awk -F'.' '{print $1"."$2-1}')
echo "previous_major_version=$previous_major_version" >>$GITHUB_ENV
echo "Previous major version: $previous_major_version"


all_releases=$(curl -s "https://api.github.com/repos/actions/runner/releases")

releases_previous_major=$(echo "$all_releases" | jq -r "map(select(.tag_name | startswith(\"$previous_major_version\")))")

latest_release_previous_major=$(echo "$releases_previous_major" | jq -r '.[0].tag_name')
echo "latest_release_previous_major=$latest_release_previous_major"
echo "latest_release_previous_major=$latest_release_previous_major" >>$GITHUB_ENV

latest_release_previous_major_date=$(echo "$releases_previous_major" | jq -r '.[0].published_at')
# echo "latest_release_previous_major_date=$latest_release_previous_major_date"
echo "latest_release_previous_major_date=$latest_release_previous_major_date" >> $GITHUB_ENV

CURRENT_VERSION=$(grep -A 1 'name: summerwind/actions-runner' './kustomization.yml' | grep 'newTag' | awk -F 'newTag:' '{print $2}' | sed 's/^[ \t]//;s/[ \t]$//')
echo "CURRENT_VERSION=$CURRENT_VERSION"
echo "CURRENT_VERSION=$CURRENT_VERSION" >>$GITHUB_ENV

extracted_version=$(echo "$CURRENT_VERSION" | cut -d'-' -f1)
echo "extracted_version: ${extracted_version}"

latest_release_date_formatted=$(date -d "$latest_release_date" '+%Y-%m-%d')
echo "latest_release_date_formatted: $latest_release_date_formatted"

latest_release_previous_major_date_formatted=$(date -d "$latest_release_previous_major_date" '+%Y-%m-%d')
echo "latest_release_previous_major_date_formatted: $latest_release_previous_major_date_formatted"

date_diff=$(( ($(date -d "$latest_release_date" '+%s') - $(date -d "$latest_release_previous_major_date" '+%s')) / 86400 ))

echo "date_diff=$date_diff"

expected_date_diff=30

if [ "$latest_release_previous_major" != "" ]; then
  echo "Latest release from the previous major version: $latest_release_previous_major"
  
  if [ "$latest_release_previous_major" != "$extracted_version" ]; then
    if [ "$date_diff" -ge "$expected_date_diff" ]; then
      echo "Upgrade timeframe is over for previous major version. Upgradding to latest version"
      new_tag_value="${latest_release}"
    else
      new_tag_value="${latest_release_previous_major}"
    fi
    echo "new_tag_value: ${new_tag_value}"
    echo "new_tag_value=$new_tag_value" >>$GITHUB_ENV
    sed -i "s/\(newTag: \)$extracted_version/\1$new_tag_value/g" "$yaml_file"    
  else
    echo "No new releases available"
  fi
else
  echo "No releases available for the previous major version"
fi