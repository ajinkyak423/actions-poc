import re

# Define the path to your Kustomization YAML file
kustomization_file_path = 'kustomization.yml'

# Define the newTag value you want to set
new_tag_value = 'v2.305.0-ubuntu-20.04'

# Read the content of the Kustomization file
with open(kustomization_file_path, 'r') as kustomization_file:
    file_content = kustomization_file.read()

# Define a regular expression pattern to find the image entry
pattern = r"^- name: summerwind/actions-runner[\s\S]*?newTag: .*$"

# Replace the newTag value in the image entry
new_content = re.sub(pattern, f"- name: summerwind/actions-runner\n    newTag: {new_tag_value}", file_content, flags=re.MULTILINE)

# Write the updated content back to the file
with open(kustomization_file_path, 'w') as kustomization_file:
    kustomization_file.write(new_content)

print(f"Updated newTag for 'summerwind/actions-runner' to '{new_tag_value}'.")
