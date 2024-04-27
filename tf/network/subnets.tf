resource "aws_subnet" "public-subnets" {
  count = 4
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnets" {
  count = 4
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${5+count.index}.0/24"

  tags = {
    Name = "public-subnet-${count.index}"
  }
}