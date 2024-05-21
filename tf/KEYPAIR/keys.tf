resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-public-key"
  public_key = var.ec2-public_key
}
