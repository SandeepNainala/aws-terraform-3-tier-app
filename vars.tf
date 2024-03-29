variable "region" {
  type    = string
  default = "us-east-1"
}
variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}

variable "az" {
  type        = list(any)
  description = "availability zone of the public and private subnets"
  default     = ["us-east-1a","us-east-1b"]
}

variable "main_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_cidr_blocks" {
  type    = list(string)
  default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "allocated_storage" {
  type    = number
  default = 10
}
variable "engine_version" {
  type    = number
  default = "5.7.37"
}
variable "multi_azs" {
  type    = bool
  default = false
}
variable "db_name" {
  type    = string
  default = "mydb"
}

variable "rds_db_username" {
  type    = string
  default = "admin"
}

variable "rds_db_password" {
  type    = string
  default = "itismydb"
}
variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}
variable "db_engine" {
  type    = string
  default = "mydb"
}