module "rds" {
  source            = "./modules/rds"
  subnets           =  aws_subnet.private_subnets
  vpc_id            = aws_vpc.main.id
  from_sg          = [aws_security_group.application_tire]
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  multi_azs         = false
  db_name           = var.db_name
  db_username       = var.rds_db_username
  db_password       = var.rds_db_password
  instance_class    = var.instance_class
  db_name           = var.db_engine

}
