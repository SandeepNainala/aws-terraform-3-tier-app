
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

terraform {

  backend "s3" {
    bucket = "mybucket-1"
    key    = "key/terraform.tfstate"
    region = "us-east-1"

  }
}