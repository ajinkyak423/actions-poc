#!/bin/bash

# Define the image name and new tag
image_name="summerwind/actions-runner"
new_tag="v2.305.0-ubuntu-20.04"

# Define the path to the YAML file
yaml_file="kustomization.yml"

# Use sed to replace the newTag value using a different delimiter
sed -i "s#\(- name: $image_name\).*newTag: [^\n]*#- name: $image_name\n  newTag: $new_tag#" "$yaml_file"
