import os

env_var_name = "deploy_tanent_file"
env_var_value = "yourfile.txt"

# GitHub Actions provides the GITHUB_ENV path in the environment
github_env = os.getenv('GITHUB_ENV')

# Append the new environment variable to the GITHUB_ENV file
with open(github_env, 'a') as env_file:
    env_file.write(f"{env_var_name}={env_var_value}\n")

\\\\
sdfds
sdfsdf
sdfsdaf
iefhf
