
import re
import os

# Define the path to your Kustomization YAML file
kustomization_file_path = 'kustomization.yml'

# Read the content of the Kustomization file
with open(kustomization_file_path, 'r') as kustomization_file:
    file_content = kustomization_file.read()

# Define a regular expression pattern to find the image entry
pattern = r"^- name: summerwind/actions-runner[\s\S]*?newTag: .*$"

# Extract the newTag value from the environment variable
new_tag_value = os.environ.get('latest_version_previous_major')

# Replace the newTag value in the image entry with proper indentation
new_content = re.sub(pattern, f"- name: summerwind/actions-runner\n  newTag: {new_tag_value}", file_content, flags=re.MULTILINE)

# Write the updated content back to the file
with open(kustomization_file_path, 'w') as kustomization_file:
    kustomization_file.write(new_content)

print(f"Updated newTag for 'summerwind/actions-runner' to '{new_tag_value}'.")
