output "vpc_id" {
    value = aws_vpc.main.id
}

output "private-subnets-id" {
    value = aws_subnet.private-subnets[*].id
}

output "public-subnets-id" {
  value = aws_subnet.public-subnets[*].id
}

output "vpc-cidr-block" {
  value = aws_vpc.main.cidr_block
}

output "azs" {
  value = data.aws_availability_zones.available.names
}