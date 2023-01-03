import requests
from datetime import datetime
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def send_teams(region, f_id, msg):
    """ Send payload to slack """
    webhook_url = "YourTeamsWebhook"
    footer_icon = 'https://howtofightnow.com/wp-content/uploads/2018/11/cartoon-firewall-hi.png'
    color = '#E01E5A'
    level = ':boom: ALERT :boom:'
    curr_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    console_url = 'https://console.aws.amazon.com/securityhub'
    fallback = f"finding - {console_url}/home?region={region}#/findings?search=id%3D${f_id}"
    payload = {"text": f"AWS SecurityHub finding in {region} {msg}"}
    
    requests.post(webhook_url, data=json.dumps(payload), headers={'Content-Type': 'application/json'})
    

def send_slack(region, f_id, msg):
    """ Send payload to slack """
    webhook_url = "YourSlackWebHook"
    footer_icon = 'https://howtofightnow.com/wp-content/uploads/2018/11/cartoon-firewall-hi.png'
    color = '#E01E5A'
    level = ':boom: ALERT :boom:'
    curr_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    console_url = 'https://console.aws.amazon.com/guardduty'
    fallback = f"finding - {console_url}/home?region={region}#/findings?search=id%3D${f_id}"
    payload = {"username": "SecurityHub",
               "attachments": [{"fallback": fallback,
                                "pretext": level,
                                "color": color,
                                "text": f"AWS SecurityHub finding in {region} {msg}",
                                "footer": f"{curr_time}\n{fallback}",
                                "footer_icon": footer_icon}]}
    requests.post(webhook_url, data=json.dumps(payload), headers={'Content-Type': 'application/json'})


def lambda_handler(event, context):
    logger.info("log -- Event: %s " % json.dumps(event))
    finding_id = event['Id']
    finding_desc = event['Description']
    region = event['Region']
    severity = event['Severity']
    finding_type = event['Type']
    msg = f"Finding new detection: severity {severity}, type: {finding_type}"
    send_slack(region, finding_id, msg)
    send_teams(region, finding_id, msg)
    return {"Status": "Ok"}

