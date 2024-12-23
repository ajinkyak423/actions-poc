#!/bin/bash

yaml_file="kustomization.yml"
arc_yaml_files=$(find apps/arc-runners -type f -name "*values*.yml")
echo "arc_yaml_files: $arc_yaml_files"

release_metadata=$(curl -s https://api.github.com/repos/actions/runner/releases/latest)

latest_release=$(echo "$release_metadata" | jq -r '.tag_name')
echo "latest_release=$latest_release" >>$GITHUB_ENV
echo "latest_release: $latest_release"

latest_release_date=$(echo "$release_metadata" | jq -r '.published_at')

latest_release_date_formatted=$(date -d "$latest_release_date" '+%Y-%m-%d')
echo "latest_release_date_formatted: $latest_release_date_formatted"

current_date=$(date '+%s')
current_date_formatted=$(date -d "@$current_date" '+%Y-%m-%d')
echo "current_date (Y-M-D): $current_date_formatted"

curr_date_diff=$(( (current_date - $(date -d "$latest_release_date" '+%s')) / 86400 ))  
echo "Latest release is $curr_date_diff days old"

previous_major_version=$(echo $latest_release | awk -F'.' '{print $1"."$2-1}')
echo "previous_major_version=$previous_major_version" >>$GITHUB_ENV
echo "Previous major version: $previous_major_version"

all_releases=$(curl -s "https://api.github.com/repos/actions/runner/releases")

releases_previous_major=$(echo "$all_releases" | jq -r "map(select(.tag_name | startswith(\"$previous_major_version\")))")

latest_release_previous_major=$(echo "$releases_previous_major" | jq -r '.[0].tag_name')
echo "latest_release_previous_major=$latest_release_previous_major" >>$GITHUB_ENV
echo "latest_release_previous_major: $latest_release_previous_major"

latest_release_previous_major_date=$(echo "$releases_previous_major" | jq -r '.[0].published_at')

latest_release_previous_major_date_formatted=$(date -d "$latest_release_previous_major_date" '+%Y-%m-%d')
echo "latest_release_previous_major_date_formatted: $latest_release_previous_major_date_formatted"

current_version=$(grep -A 1 'name: summerwind/actions-runner' "$yaml_file" | grep 'newTag' | awk -F 'newTag:' '{print $2}' | sed 's/^[ \t]//;s/[ \t]$//'| cut -d'-' -f1)
echo "current_version=$current_version" >>$GITHUB_ENV
echo "current_version: $current_version"

expected_date_diff=30

if [ "$latest_release" != "$current_version" ]; then
  new_tag_value=""
  if [ "$curr_date_diff" -ge "$expected_date_diff" ]; then
    echo "Upgrade timeframe (30 days) is over for previous major version. Upgradding to latest version"
    new_tag_value="${latest_release}"
  elif [ "$current_version" != "$latest_release_previous_major" ]; then
    new_tag_value="${latest_release_previous_major}"
  fi

  if [[ ! -z "$new_tag_value" ]]; then
    echo "new_tag_value: ${new_tag_value}"
    echo "new_tag_value=$new_tag_value" >>$GITHUB_ENV
    sed -i "s/\(newTag: \)$current_version/\1$new_tag_value/g" "$yaml_file"

    arc_tag_current_version="ajinka4ridecell/action-runner:${current_version}"
    echo "arc_tag_current_version=$arc_tag_current_version"
    arc_tag_new_version="ajinka4ridecell/action-runner:${new_tag_value}"
    arc_tag_value=$(echo "$new_tag_value" | sed 's/^v//')
    echo "arc_tag_value: ${arc_tag_value}"
    echo "arc_tag_value=$arc_tag_value" >>$GITHUB_ENV
    for arc_yaml_file in $arc_yaml_files; do
      sed -i "s|\(image: \)$arc_tag_current_version|\1$arc_tag_new_version|g" "$arc_yaml_file"
    done

  else
    echo "No need to upgrade."
  fi
  
else
  echo "No new releases available."
fi
