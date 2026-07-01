import subprocess
import requests
import json

API_URL = "https://oxn7tku1ic.execute-api.us-east-1.amazonaws.com/prod/trigger-incident"

MODEL_NAME = "TBL_POLICY_MEASURES"

def run_dbt():
    print("Running dbt model...")

    result = subprocess.run(
        ["dbt", "build", "--select", MODEL_NAME],
        capture_output=True,
        text=True
    )

    return result


def send_alert(status, logs):
    payload = {
        "pipeline_name": MODEL_NAME,
        "status": status,
        "error_message": logs[:500],   # truncate logs
        "variables": {
            "market": "MX",
            "load_type": "incremental"
        }
    }

    try:
        response = requests.post(API_URL, json=payload)
        print(f"✅ API Triggered | Status Code: {response.status_code}")
    except Exception as e:
        print("❌ API call failed:", str(e))


if __name__ == "__main__":
    result = run_dbt()

    if result.returncode == 0:
        print("✅ dbt run SUCCESS")
        send_alert("SUCCESS", result.stdout)
    else:
        print("❌ dbt run FAILED")
        send_alert("FAILED", result.stderr)