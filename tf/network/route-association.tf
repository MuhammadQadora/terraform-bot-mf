resource "aws_route_table_association" "public-subnets-association" {
  count = 4
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-subnets-association" {
  count = 4
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-rt.id
}