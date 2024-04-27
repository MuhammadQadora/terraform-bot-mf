# creates public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public-cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.public-rt-name
  }
}
# creates private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.private-rt-name
  }
}