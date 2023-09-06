#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"

new_tag="$1"  # The newTag value is passed as the first argument

sed -i "s/\( name: summerwind/actions-runner\n *newTag: \)./\1$1/" "kustomization.yml"

echo "Image tag for summerwind/actions-runner updated to $1"