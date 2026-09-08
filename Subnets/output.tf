output "private-subnets" {
  value = [alicloud_vswitch.private-subnet-1a.id, alicloud_vswitch.private-subnet-1b.id]
}