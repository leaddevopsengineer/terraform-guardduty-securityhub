import json
import boto3
import os
import datetime

stepfunctions_client = boto3.client('stepfunctions')

def lambda_handler(event, context):
    event_record = event
    
    name = "GuardDuty"
    client = "Pareto"
    unique_id = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")

    exec_name = f"{client}-{name}-{unique_id}"

    response = stepfunctions_client.start_execution(
        stateMachineArn=os.environ['STATE_MACHINE'],
        name=exec_name,
        input=json.dumps(event_record)
        )
        
    return json.dumps(response, default=str)

