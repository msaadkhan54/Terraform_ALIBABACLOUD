terraform {
  required_version = ">= 1.0"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.285.0"
    }
  }
}

provider "alicloud" {
  region  = "us-east-1"
  profile = "default"
}


module "VPC" {
  source = "./VPC"
}

module "subnet" {
  source = "./Subnets"
  vpc_id = module.VPC.vpc_id
}

module "ack" {
  source          = "./ACK"
  private-subnets = module.subnet.private-subnets
}