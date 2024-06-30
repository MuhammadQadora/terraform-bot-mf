import json
import boto3
import os
cloudwatch = boto3.client('cloudwatch',region_name=os.environ['region'])
sqs_client = boto3.resource('sqs', region_name=os.environ['region'])
asg_client = boto3.client('autoscaling', region_name=os.environ['region'])
def lambda_handler(event, context):
    
    AUTOSCALING_GROUP_NAME = os.environ['AUTOSCALING_GROUP_NAME']
    QUEUE_NAME = os.environ['QUEUE_NAME']
    
    queue = sqs_client.get_queue_by_name(QueueName=QUEUE_NAME)
    msgs_in_queue = int(queue.attributes.get('ApproximateNumberOfMessages'))
    asg_groups = asg_client.describe_auto_scaling_groups(AutoScalingGroupNames=[AUTOSCALING_GROUP_NAME])['AutoScalingGroups']
    
    if not asg_groups:
        raise RuntimeError('Autoscaling group not found')
    else:
        asg_size = asg_groups[0]['DesiredCapacity']
        print(asg_size)
    if asg_size == 0:
        asg_size = 1
    backlog_per_instance = msgs_in_queue / asg_size
    
# TODO send backlog_per_instance to cloudwatch...
# Put custom metrics
    cloudwatch.put_metric_data(
        MetricData=[
            {
                'MetricName': 'BacklogPerInstance',
                'Dimensions': [
                    {
                        'Name': 'queue_name',
                        'Value': QUEUE_NAME
                    },
                ],
                'Unit': 'None',
                'Value': backlog_per_instance
            },
        ],
        Namespace='yolov5/sqs'
        )
    return {
        "Status-Code": 200
    }