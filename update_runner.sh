#!/bin/bash

# Define the file path
file_path="kustomization.yml"

# Define the image name
image_name="summerwind/actions-runner"

# Get the newTag value from the argument
new_tag="$1"  # The newTag value is passed as the first argument

# Use sed to find and replace the newTag value
sed -i "s/\( name: $image_name\n *newTag: \)./\1$new_tag/" "$file_path"

echo "Image tag for $image_name updated to $new_tag"