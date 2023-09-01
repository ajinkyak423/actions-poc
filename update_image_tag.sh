#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"

new_tag="$1"  # The newTag value is passed as the first argument

sed -i "s/\( name: $image_name\n *newTag: \)./\1$new_tag/" "$file_path"

echo "Image tag for $image_name updated to $new_tag"