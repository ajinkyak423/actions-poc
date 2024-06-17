import os
import glob
import logging
import argparse
from slack_sdk import WebClient

logging.basicConfig(level=logging.ERROR)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--token", required=True, help="Slack API token")
    parser.add_argument("-d", "--directory", default=os.getcwd(), help="Directory to search for files")
    parser.add_argument("-p", "--pattern", default="*", help="File pattern to upload (e.g., *.csv)")
    args = parser.parse_args()
    token = args.token
    directory = args.directory
    file_pattern = args.pattern

    client = WebClient(token=token)

    auth_test = client.auth_test()
    if auth_test.get("ok"):
        print("Authentication successful")
    else:
        print("Error: Authentication failed")

    files = glob.glob(os.path.join(directory, file_pattern))
    print(f"{file_pattern} files found in directory {directory}: {files}")

    for file_path in files:
        try:
            new_file = client.files_upload_v2(
                title="My Test Text File",
                file=file_path,
                initial_comment="Here is the file:",
            )

            file_url = new_file.get("file").get("permalink")

            new_message = client.chat_postMessage(
                channel="C05QXU43GUQ",
                text=f"Here is the <{file_url}|file>",
            )

            if new_message.get("ok"):
                print(f"File {file_path} uploaded successfully")

        except Exception as e:
            print(f"Error uploading file {file_path}: {e}")

if __name__ == "__main__":
    main()