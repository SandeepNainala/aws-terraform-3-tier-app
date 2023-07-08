variable "subnets" {
  type   = list(any)
}
variable "allocated_storage" {
  type    = number
  default = 10
}
variable "engine" {
  type    = string
}
variable "engine_version" {
  type    = string
  default = "5.7.37"
}
variable "multi_az" {
  type    = bool
  default = false
}
variable "instance_class" {
  type    = string
}
variable "db_username" {
  type    = string
  default = "naidu"
}
variable "db_password" {
  type    = string
  default = "itismydb"
}