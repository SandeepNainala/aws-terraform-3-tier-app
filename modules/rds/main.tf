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
  vpc_security_group_ids      = [aws_security_group.]

}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = var.subnets.*.id

  tags = {
    Name = "db_subnet_group"
  }
}