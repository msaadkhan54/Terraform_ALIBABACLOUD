resource "alicloud_vpc" "main_vpc" {
  vpc_name = "saad-vpc"
  cidr_block = "10.0.0.0/16"
  dns_hostname_status = "DISABLED"
}

