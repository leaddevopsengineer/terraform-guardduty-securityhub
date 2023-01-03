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
    instance_id = find_values('InstanceId', json.dumps(event))
    ec2 = boto3.client('ec2', region_name=region)
    logger.info("log -- Event: %s " % json.dumps(event))

    try:
        if 'Backdoor:EC2/C&CActivity.B!DNS' in event["Type"]:
            ec2.stop_instances(InstanceIds=instance_id)
        elif 'UnauthorizedAccess:EC2/SSHBruteForce' in event["Type"]:
            sg_rules_list = [{'SecurityGroupRuleId': 'sgr-0645551607c6da57b',
                  'SecurityGroupRule': {
                      'IpProtocol': 'tcp',
                      'FromPort': 22,
                      'ToPort': 22,
                      'CidrIpv4': '73.75.251.99/32',
                      'Description': 'added ssh port'
                  }
                  }
                 ]
            response = ec2.modify_security_group_rules(GroupId='sg-0ff5bcbfd267a2b3a', SecurityGroupRules=sg_rules_list)
            print(response)

        else:
            instance_id = find_values('InstanceId', json.dumps(event))
            logger.warning("log -- unable to determine required info from finding - instanceID: %s" % (instance_id))
    except Exception as e:
        logger.error('log -- something went wrong.')
        raise

    
    return event