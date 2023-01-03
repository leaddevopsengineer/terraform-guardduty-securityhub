import json
import botocore
import boto3
import os
import zipfile
from io import BytesIO

tablename = "SecurityResponse"

def lambda_handler(event, context):
    client = boto3.client('dynamodb')

    # Get an array of table names associated with the current account and endpoint.
    response = client.list_tables()

    if tablename in response['TableNames']:
        table_found = True
    else:
        table_found = False
        # Get the service resource.
        dynamodb = boto3.resource('dynamodb')

        # Create the DynamoDB table called followers
        table = dynamodb.create_table(
            TableName = tablename,
            KeySchema=[
                {
                    'AttributeName': 'EventName',
                    'KeyType': 'HASH'  #Partition key
                },
                                {
                    'AttributeName': 'Timestamp',
                    'KeyType':  'RANGE'
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'EventName',
                    'AttributeType': 'S'
                },
                                {
                    'AttributeName': 'Timestamp',
                    'AttributeType': 'S'
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 1,
                'WriteCapacityUnits': 1
            }
        )

        # Wait until the table exists.
        table.meta.client.get_waiter('table_exists').wait(TableName=tablename)

    return event


