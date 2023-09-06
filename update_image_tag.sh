#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"

new_tag="$1"  # The newTag value is passed as the first argument

# Check if there are changes to commit
if git diff-index --quiet HEAD --; then
  echo "No changes to commit."
else
  # Perform the update only if the tag has changed
  current_tag=$(grep -Po 'name: summerwind/actions-runner\n *newTag: \K.*' "$file_path")
  if [ "$current_tag" != "$new_tag" ]; then
    sed -i "s| name: summerwind/actions-runner\n *newTag: .*| name: summerwind/actions-runner\n  newTag: $new_tag|" "$file_path"
    echo "Image tag for summerwind/actions-runner updated to $new_tag"

    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    git checkout -b feature/update-file  # Create a new branch for the changes
    git add .
    git commit -m "Update file via GitHub Actions"
  else
    echo "No changes needed. Current tag is already $new_tag."
  fi
fi
