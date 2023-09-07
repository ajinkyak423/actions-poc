#!/bin/bash

# Define the new image tag
NEW_IMAGE_TAG="v2.305.0-ubuntu-20.04"

# Define the image name you want to update
IMAGE_NAME="summerwind/actions-runner"

# Update the image tags in the Kustomization file
sed -i "/name: $IMAGE_NAME/{N;s/\n  newTag: .*/\n  newTag: $NEW_IMAGE_TAG/}" kustomization.yml
