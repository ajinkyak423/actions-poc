latest_release=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')
echo "latest_release=$latest_release" >>$GITHUB_ENV
echo "latest_release=$latest_release"

previous_major_version=$(echo $latest_release | awk -F'.' '{print $1"."$2-1}')
echo "Previous major version: $previous_major_version"

# Get all releases from the repository
all_releases=$(curl -s "https://api.github.com/repos/actions/runner/releases")

# Filter releases by the previous major version
releases_previous_major=$(echo "$all_releases" | jq -r "map(select(.tag_name | startswith(\"$previous_major_version\")))")

# Get the latest release from the previous major version
latest_release_previous_major=$(echo "$releases_previous_major" | jq -r '.[0].tag_name')
echo "latest_release_previous_major=$latest_release_previous_major"
echo "latest_release_previous_major=$latest_release_previous_major" >>$GITHUB_ENV

CURRENT_VERSION=$(grep -A 1 'name: summerwind/actions-runner' './kustomization.yml' | grep 'newTag' | awk -F 'newTag:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
echo "CURRENT_VERSION=$CURRENT_VERSION"
echo "CURRENT_VERSION=$CURRENT_VERSION" >>$GITHUB_ENV

if [ "$latest_release_previous_major" != "" ]; then
  echo "Latest release from the previous major version: $latest_release_previous_major"

  if [ "$latest_release_previous_major" != "$CURRENT_VERSION" ]; then
    echo "New release available: $latest_release_previous_major"
    echo "::set-output name=notify::true"
  else
    echo "No new releases available"
    echo "::set-output name=notify::false"
  fi
else
  echo "No releases available for the previous major version"
fi
