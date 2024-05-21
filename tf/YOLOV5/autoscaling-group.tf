resource "aws_autoscaling_group" "yolov5-autoscaling-group" {
  name                      = var.autoscaling-group-name
  max_size                  = 10
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = var.public-azs
  launch_template {
    # name = aws_launch_template.yolov5-launchtemplate.name
    id = aws_launch_template.yolov5-launchtemplate.id
    version = "$Latest"

  }
  tag {
    key                 = "Name"
    value               = "autoscaling-yolov5-terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "custom-policy" {
  depends_on = [ aws_autoscaling_group.yolov5-autoscaling-group ]
  autoscaling_group_name = var.autoscaling-group-name
  name                   = "sqs-custom-scaling-policy-for-worker-nodes"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value = 10
    customized_metric_specification {
      metrics {
        label = "Get the queue size (the number of messages waiting to be processed)"
        id    = "m1"
        metric_stat {
          metric {
            namespace   = "yolov5/sqs"
            metric_name = "BacklogPerInstance"
            dimensions {
              name  = "queue_name"
              value = "${var.sqs-name}"
            }
          }
          stat = "Average"
        }
        return_data = true
      }
    }
  }
}