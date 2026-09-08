output "vpc_id" {
  value = alicloud_vpc.main_vpc.id
}

output "vpc" {
  value= alicloud_vpc.main_vpc.name
}