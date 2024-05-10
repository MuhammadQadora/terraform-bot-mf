data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public-subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${(length(data.aws_availability_zones.available.names)+1)+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index}"
  }
}