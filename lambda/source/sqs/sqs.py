import json
import boto3
import os
import datetime

queue_name = os.getenv('QUEUE_NAME')

def lambda_handler(event, context):

  data = json.dumps(event)

  # Retrieving a queue by its name
  sqs = boto3.resource('sqs')
  queue = sqs.get_queue_by_name(QueueName=queue_name)

  queue.send_message(MessageBody=data, MessageGroupId='EventData')

  return event
