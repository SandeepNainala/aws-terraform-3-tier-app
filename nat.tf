resource "aws_nat_gateway" "gw" {
  count         = length (aws_subnet.public_subnets)
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  connectivity_type = "private"
  depends_on = [aws_internet_gateway.gw.id]

  tags = {
    Name = "NAT"
  }
}