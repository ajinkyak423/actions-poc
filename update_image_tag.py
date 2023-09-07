import yaml

# Define the file path of your Kustomization file
kustomization_file_path = 'kustomization.yml'

# Define the newTag value you want to set
new_tag = 'v2.305.0-ubuntu-20.04'

# Load the Kustomization file
with open(kustomization_file_path, 'r') as file:
    kustomization_data = yaml.safe_load(file)

# Update the newTag value for the specified image
for image in kustomization_data.get('images', []):
    if image.get('name') == 'summerwind/actions-runner':
        image['newTag'] = new_tag

# Write the modified Kustomization data back to the file
with open(kustomization_file_path, 'w') as file:
    yaml.dump(kustomization_data, file, default_flow_style=False)

print(f"Updated newTag for 'summerwind/actions-runner' to '{new_tag}'")
