#!/bin/bash

# Define the new image version
NEW_IMAGE_TAG="v2.305.0-ubuntu-20.04"

# Update the image tag in the Kustomization file and remove the old one
sed -i "s|name: summerwind/actions-runner.*|name: summerwind/actions-runner\n  newTag: $NEW_IMAGE_TAG|" kustomization.yml
