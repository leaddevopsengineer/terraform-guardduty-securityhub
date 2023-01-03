import json
import boto3
import logging

region = 'us-west-2'

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def find_values(id, json_repr):
    response = []

    def _decode_dict(a_dict):
        try:
            response.append(a_dict[id])
        except KeyError:
            pass
        return a_dict

    json.loads(json_repr, object_hook=_decode_dict) # Return value ignored.
    return response

def lambda_handler(event, context):
    
    ec2 = boto3.client('ec2', region_name=region)
    logger.info("log -- Event: %s " % json.dumps(event))

    try:
        if 'Backdoor:EC2/C&CActivity.B!DNS' in event["Type"]:
            instance_id = find_values('InstanceId', json.dumps(event))
            ec2.stop_instances(InstanceIds=instance_id)
        else:
            instance_id = find_values('InstanceId', json.dumps(event))
            logger.warning("log -- The instance has already been stopped - instanceID: %s" % (instance_id))
    except Exception as e:
        logger.warning("log -- The instance has already been stopped - instanceID: %s" % (instance_id))
        pass

    
    return event