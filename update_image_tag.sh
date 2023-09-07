#!/bin/bash

# Define the image name and new tag
image_name="summerwind/actions-runner"
new_tag="v2.305.0-ubuntu-20.04"

# Define the path to the YAML file
yaml_file="kustomization.yml"

# Use sed to remove the old newTag value and add the new one
sed -i -e "/- name: $image_name/{N; s/\(newTag: \)[^\n]*\n/\1$new_tag\n/}" "$yaml_file"
