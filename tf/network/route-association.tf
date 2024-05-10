resource "aws_route_table_association" "public-subnets-association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
  depends_on = [ aws_route_table.public-rt ]
}

resource "aws_route_table_association" "private-subnets-association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-rt.id
  depends_on = [ aws_route_table.private-rt ]
}