#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"
new_tag="v2.305.0-ubuntu-20.04" # The newTag value is passed as the first argument

echo "Image name: $image_name"
echo "New tag: $new_tag"

sed -n "/\(name: $image_name\)/,/\(name: .*\)/p" "$file_path"

sed -i "s|\(name: $image_name\n\s*newTag: \).*|\1$new_tag|" "$file_path"

echo "Image tag for $image_name updated to $new_tag"