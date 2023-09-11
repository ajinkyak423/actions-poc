import re
import os

kustomization_file_path = 'kustomization.yml'

with open(kustomization_file_path, 'r') as kustomization_file:
    file_content = kustomization_file.read()
pattern = r"^- name: summerwind/actions-runner[\s\S]*?newTag: .*$"

# latest_version_previous_major = os.environ.get('latest_release_previous_major')

desired_version = os.environ.get('DESIRED_VERSION')

new_tag_value = f"{DESIRED_VERSION}-ubuntu-20.04"

new_content = re.sub(pattern, f"- name: summerwind/actions-runner\n  newTag: {new_tag_value}", file_content, flags=re.MULTILINE)
with open(kustomization_file_path, 'w') as kustomization_file:
    kustomization_file.write(new_content)

print(f"Updated newTag for 'summerwind/actions-runner' to '{new_tag_value}'.")
