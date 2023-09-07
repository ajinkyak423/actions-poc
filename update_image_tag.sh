#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"
new_tag="v2.305.0-ubuntu-20.04" # The newTag value is passed as the first argument

# Escape special characters in image_name and new_tag
image_name_escaped=$(sed 's/[[\.*^$/]/\\&/g' <<< "$image_name")
new_tag_escaped=$(sed 's/[\/&]/\\&/g' <<< "$new_tag")

sed -i "s|\(name: $image_name_escaped\n\s*newTag: \).*|\1$new_tag_escaped|" "$file_path"

echo "Image tag for $image_name updated to $new_tag"
