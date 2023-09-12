#!/bin/bash

# Define the path to your Kustomization YAML file
yaml_file="kustomization.yml"
echo $yaml_file
# Read the content of the Kustomization file
file_content=$(cat "$yaml_file")
# Extract the newTag value from the environment variable and format it
latest_version_previous_major="$latest_release_previous_major"
# saving newTag string to variable
new_tag_value="${latest_version_previous_major}-ubuntu-20.04"
# new_tag_value="v2.304.8"
#parse yaml
current_tag_value=$(sed -n '/^- name: summerwind\/actions-runner/{n;p;}' kustomization.yml | awk '{print $2}')
extracted_version=$(echo "$current_tag_value" | cut -d'-' -f1)
echo "$extracted_version" 
#updating kustomization.yaml
sed -i '' "s/\(newTag: \)$extracted_version/\1$new_tag_value/g" "$yaml_file"
echo "Value: $current_tag_value"
new_tag="${new_tag_value}-ubuntu-20.04"
echo "New Tag: $new_tag"
