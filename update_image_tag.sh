#!/bin/bash

# Define the new image tag
NEW_IMAGE_TAG="v2.305.0-ubuntu-20.04"

# Debugging statements
echo "IMAGE_NAME: $IMAGE_NAME"
grep "$IMAGE_NAME" kustomization.yml  # Print the line matching IMAGE_NAME


# Update the image tag in the Kustomization file for the specific image name
IMAGE_NAME="summerwind/actions-runner"
sed -i "s|name: $IMAGE_NAME\n  newTag: .*|name: $IMAGE_NAME\n  newTag: $NEW_IMAGE_TAG|" kustomization.yml
