#!/bin/bash
# Define the new tag value
newTag="v2.305.0-ubuntu-20.04"

# Define the path to your Kustomization file
kustomizationFile="kustomization.yml"

# Use sed to replace the newTag value
sed -i "s|name: summerwind/actions-runner\n  newTag:.*|name: summerwind/actions-runner\n  newTag: $newTag|" "$kustomizationFile"