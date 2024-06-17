import os
import time
import glob
import argparse
import subprocess
import pandas as pd
import ruamel.yaml as yaml
from datetime import datetime
from kubernetes import client, config

yaml = yaml.YAML()
config.load_kube_config()
api_instance = client.CoreV1Api()

def convert_bytes_to_mb(value, resource_type):
    if type(value) is int or float:
        if resource_type == 'cpu':
            return f"{value} m"
        elif resource_type == 'memory':
            return f"{round(value / (1024 * 1024), 2)} Mi"
    return value

def find_critical_resources(recommended):
    feilds_to_add_in_csv = []
    if recommended.get('requests').get('cpu').get('severity') == 'CRITICAL':
        feilds_to_add_in_csv.append('requests.cpu')
    if recommended.get('requests').get('memory').get('severity') == 'CRITICAL':
        feilds_to_add_in_csv.append('requests.memory')
    if recommended.get('limits').get('cpu').get('severity') == 'CRITICAL':
        feilds_to_add_in_csv.append('limits.cpu')
    if recommended.get('limits').get('memory').get('severity') == 'CRITICAL':
        feilds_to_add_in_csv.append('limits.memory')

    return feilds_to_add_in_csv

def process_critical_resources(object, recommended, feilds_to_add_in_csv, data):
    resource_values = {
        'requested_cpu': 'No change -> No change',
        'limit_cpu': 'No change -> No change',
        'requested_memory': 'No change -> No change',
        'limit_memory': 'No change -> No change',
    }

    for feild in feilds_to_add_in_csv:
        resource_type, resource_name = feild.split('.')
        allocated_value = convert_bytes_to_mb(object.get("allocations", {}).get(resource_type, {}).get(resource_name, {}), resource_name)
        recommended_value = convert_bytes_to_mb(recommended.get(resource_type, {}).get(resource_name, {}).get('value', 'N/A'), resource_name)

        combined_value = f"{allocated_value} -> {recommended_value}"

        if resource_type == 'requests' and resource_name == 'cpu':
            resource_values['requested_cpu'] = combined_value
        elif resource_type == 'limits' and resource_name == 'cpu':
            resource_values['limit_cpu'] = combined_value
        elif resource_type == 'requests' and resource_name == 'memory':
            resource_values['requested_memory'] = combined_value
        elif resource_type == 'limits' and resource_name == 'memory':
            resource_values['limit_memory'] = combined_value

    data.append({
        'Namespace': object.get("namespace"),
        'Kind': object.get("kind"),
        'Name': object.get("name"),
        'Container Name': object.get("container"),
        'Requested-CPU': resource_values['requested_cpu'],
        'Limit-CPU': resource_values['limit_cpu'],
        'Requested-Memory': resource_values['requested_memory'],
        'Limit-Memory': resource_values['limit_memory'],
    })

def create_csv_file():
    csv_file = datetime.now().strftime("%Y_%m_%d") + ".csv"
    print("Creating CSV file: ", csv_file)
    all_yaml_files = glob.glob(os.path.join(os.getcwd(), "batch-*.yaml"))
    data = []
    if all_yaml_files:
        for yaml_file in all_yaml_files:
            print("processing file: ", yaml_file)
            with open(yaml_file) as f:
                yaml_data = yaml.load(f)
                if yaml_data:
                    for item in yaml_data['scans']:
                        if item.get('severity', {}) == 'CRITICAL':
                            object = item.get('object', {})
                            recommended = item.get('recommended', {})
                            feilds_to_add_in_csv = find_critical_resources(recommended)
                            if feilds_to_add_in_csv:
                                process_critical_resources(object, recommended, feilds_to_add_in_csv, data)
                            else:
                                print("No critical resources found")
                                return
                else:
                    print("No yaml_data in file: ", yaml_file)
    else:
        print("No YAML files found")
        return

    df = pd.DataFrame(data)
    df.to_csv(csv_file, index=True)
    print(f"CSV file {csv_file} created with {len(df)} rows")

def run_krr(prometheus_url, namespaces, batch_size, sleep_time):
    for i in range(0, len(namespaces), batch_size):
        namespace_batch = namespaces[i:i+batch_size]
        print("Processing Namespcaes: ", namespace_batch)
        namespace_batch_command = " ".join(f"-n {ns}" for ns in namespace_batch)
        output_file = f"batch-{i}.yaml"
        try:
            command = f"krr simple -p {prometheus_url} {namespace_batch_command} -f yaml -q  > {output_file}"
            subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            print(f"::Error:: running krr for namespace {namespace_batch}:", e)
            with open(output_file, 'r') as f:
                output = f.read()
            print(output, "\n Error might be related to Prometheus connection." )
            exit(1)
        time.sleep(sleep_time)

def main():
    parser = argparse.ArgumentParser(description="Check resource limits in YAML files.")
    parser.add_argument('-p', '--prometheus_url', metavar='PROMETHEUS_URL', help="Prometheus URL")
    parser.add_argument('-b', '--batch_size', metavar='BATCH_SIZE', default=3, help="Number of namespaces to process in each batch", type=int)
    parser.add_argument('-i', '--interval', metavar='SLEEP_TIME', default=30, help="Number of seconds to sleep between batche processing", type=int)
    args = parser.parse_args()

    batch_size = args.batch_size
    sleep_time = args.interval
    prometheus_url = args.prometheus_url

    namespaces = [ns.metadata.name for ns in api_instance.list_namespace().items]

    run_krr(prometheus_url, namespaces, batch_size, sleep_time)
    create_csv_file()



if __name__ == "__main__":
    main()
