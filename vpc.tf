resource "aws_vpc" "main" {
  cidr_block       = var.main_cidr_block
  enable_dns_hostnames = true
  enable_dns_support =  true
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length (var.public_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_blocks[count.index]
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnets_${count.index+1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length (var.private_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_blocks[count.index]
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnets_${count.index+1}"
  }
}

resource "aws_security_group" "presentation_tire" {
  name        = "allow traffic to presentation tire"
  description = "Allow HTTP "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_presentation_tire.id]
  }
  ingress{
    cidr_blocks = [
    "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_presentation_tire.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "presentation_tire_sg"
  }
}

resource "aws_security_group" "alb_presentation_tire" {
  name        = "allow connection to alb presentation tire"
  description = "Allow HTTP "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_presentation_tire_sg"
  }
}

resource "aws_security_group" "application_tire" {
  name        = "allow traffic to application tire"
  description = "Allow HTTP "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_application_tire.id]
  }
  ingress{
    cidr_blocks = [
      ["10.0.1.0/24","10.0.2.0/24"]
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_application_tire.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application_tire_sg"
  }
}

resource "aws_security_group" "alb_application_tire" {
  name        = "allow connection to alb application tire"
  description = "Allow HTTP "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.presentation_tire]
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.presentation_tire.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_application_tire_sg"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw[count.index].id
  }
}

resource "aws_route_table_association" "private_route_association" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route[count.index].id
}