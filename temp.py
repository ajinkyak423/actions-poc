import os

file_path="yourfile.txt"

env_file = os.getenv('GITHUB_ENV')
with open(env_file, "a") as GITHUB_ENV_FILE:
    GITHUB_ENV_FILE.write(f"deploy_tanent_file={file_path}")
    print()
    print(GITHUB_ENV_FILE)
