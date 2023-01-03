import json
import os
import boto3
import dateutil.parser


ACLMETATABLE = os.environ['ACLMETATABLE']
ddb = boto3.resource('dynamodb')
table = ddb.Table(ACLMETATABLE)


def convert_to_epoch(timestamp):
    parsed_t = dateutil.parser.parse(timestamp)
    t_in_seconds = parsed_t.strftime('%s')
    print(t_in_seconds)
    return t_in_seconds


def create_ddb_rule(record):
    response = table.put_item(
        Item=record,
        ReturnValues='ALL_OLD'
    )
    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
        if 'Attributes' in response:
            print("updated existing record, no new IP")
            return False
        else:
            print("log -- successfully added DDB state entry %s" % (record))
            return True
    else:
        print("log -- error adding DDB state entry for %s" % (record))
        print(response)
        raise


def lambda_handler(event, context):
    print("log -- Event: %s " % json.dumps(event))
    epoch_time = convert_to_epoch(str(event['time']))
    record = {
        'EventName': str(event['detail']['title']),
        'Timestamp': str(event['time']),
        'Description': str(event['detail']['description']),
        'InstanceId': str(event['detail']['resource']['instanceDetails']['instanceId']),
        'AccountId': str(event['account']),
        'Region': str(event['region']),
        'Severity': str(event['detail']['severity']),
        'Type': str(event["detail"]["type"]),
        'Id': str(event["detail"]["id"])
        }
    result = create_ddb_rule(record)

    return record
