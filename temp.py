import os

key = "deploy_tanent_file"
value = "yourfile.txt"

print(f"::set-env name={key}::{value}")
