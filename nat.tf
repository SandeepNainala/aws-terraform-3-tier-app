resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  connectivity_type = "private"
  depends_on = [aws_internet_gateway.igw.id]

  tags = {
    Name = "NAT"
  }
}