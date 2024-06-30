data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public-subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/mf-cluster" = "shared"
  }
}

resource "aws_subnet" "private-subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${(length(data.aws_availability_zones.available.names)+1)+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/mf-cluster" = "shared"
  }
}