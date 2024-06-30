resource "aws_eip" "nat" {
    depends_on = [ aws_internet_gateway.gw ]
}