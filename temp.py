import os

key = "deploy_tanent_file"
value = "yourfile.txt"

env_file = os.getenv('GITHUB_ENV')

with open(env_file, "a") as myfile:
    myfile.write(f"{key}={value}")
