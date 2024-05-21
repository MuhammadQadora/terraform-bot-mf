resource "aws_launch_template" "yolov5-launchtemplate" {
  name = var.template-name

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = false
  disable_api_termination = false

  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.yolov5-profile.name
  }

  image_id = var.ami-id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance-type

  key_name = var.key-name
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ "${aws_security_group.yolov5-sg.id}" ]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "worker"
    }
  }

  user_data = base64encode(data.template_file.user_data.rendered)
  depends_on = [ aws_iam_role.iam_for_yolov5, data.template_file.user_data]
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
  
  vars = {
    REGION_NAME = var.region-name
    SQS_URL = var.sqs-name
    SNS_ARN = var.sns-arn
    DYNAMO_TBL = var.dynamo-table-name
  }
}