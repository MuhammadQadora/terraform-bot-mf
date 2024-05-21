resource "aws_instance" "telegrambot" {
  ami           = var.ami-id
  instance_type = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.telegrambot-profile.name
  key_name = var.key-name
  subnet_id = var.bot-subnet-id
  vpc_security_group_ids = [ aws_security_group.telegram-sg.id ]

  root_block_device {
    delete_on_termination = true
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "telegrambot"
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  depends_on = [ aws_iam_role_policy_attachment.telegrambot-attachement, aws_security_group.telegram-sg ]
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
  
  vars = {
    REGION_NAME = var.region
    GPT_TBL = var.openai-table-name
    TELEGRAM_APP_URL = var.domain-name
    SQS_URL = var.sqs-name
    SNS_ARN = var.sns-arn
    DYNAMO_TBL = var.telegram-dynamo-table-name
    SERVER_ENDPOINT = "${var.domain-name}/sns_update"
  }
}