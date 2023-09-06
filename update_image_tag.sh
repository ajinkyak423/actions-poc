#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"

new_tag="$1"  # The newTag value is passed as the first argument

sed -i "s| name: summerwind/actions-runner\n *newTag: .*| name: summerwind/actions-runner\n  newTag: $new_tag|" "$file_path"

echo "Image tag for summerwind/actions-runner updated to $new_tag"
