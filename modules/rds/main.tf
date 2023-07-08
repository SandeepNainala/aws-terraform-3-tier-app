resource "aws_db_instance" "rds" {
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.id
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  multi_az                    = var.multi_az
  instance_class              = var.instance_class
  password                    = var.db_password
  username                    = var.db_username
  skip_final_snapshot         = true
  vpc_security_group_ids      = [aws_db_security_group.rds-sg.id]

}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = var.subnets.*.id

  tags = {
    Name = "db_subnet_group"
  }
}

resource "aws_db_security_group" "rds-sg" {
  name        = "rds_sg"
  description = "Allow application tire to access the RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    description    = "EC2 to MYSQL"
    from_port      = 3306
    to_port        = 3306
    protocol       = "TCP"
    security_group = var.from_sg.*.id
  }
  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }
  tags {
    name          = "rds_sg"
  }
}