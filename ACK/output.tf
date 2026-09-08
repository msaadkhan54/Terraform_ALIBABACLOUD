# ./ACK/outputs.tf
output "cluster_id" {
  description = "The ID of the ACK cluster"
  value       = alicloud_cs_managed_kubernetes.ack.id
}