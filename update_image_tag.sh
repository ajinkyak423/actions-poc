#!/bin/bash

file_path="kustomization.yml"
image_name="summerwind/actions-runner"

new_tag="$1"  # The newTag value is passed as the first argument

# Check if there are changes to commit
if git diff-index --quiet HEAD --; then
  echo "No changes to commit."
else
  # Perform the update and commit
  sed -i "s| name: summerwind/actions-runner\n *newTag: .*| name: summerwind/actions-runner\n  newTag: $new_tag|" "$file_path"
  echo "Image tag for summerwind/actions-runner updated to $new_tag"
  
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"
  git checkout -b feature/update-file  # Create a new branch for the changes
  git add .
  git commit -m "Update file via GitHub Actions"
fi
