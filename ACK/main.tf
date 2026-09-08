
resource "alicloud_cs_managed_kubernetes" "ack" {
  name = "saad-ack-cluster"
  vswitch_ids = [
    var.private-subnets[0],
    var.private-subnets[1]
  ]

  cluster_spec = "ack.pro.small"
  pod_cidr     = "172.20.0.0/16"
  service_cidr = "172.21.0.0/20"

  slb_internet_enabled = true

  new_nat_gateway = false
}

# 2. Worker Node Pool
resource "alicloud_cs_kubernetes_node_pool" "worker_nodes" {
  node_pool_name = "saad-worker-pool"
  cluster_id     = alicloud_cs_managed_kubernetes.ack.id
  vswitch_ids = [
    var.private-subnets[0],
    var.private-subnets[1]
  ]

  desired_size   = 2
  instance_types = ["ecs.e-c1m2.large"]
  image_type     = "AliyunLinux3ContainerOptimized"
  runtime_name   = "containerd"

  system_disk_category = "cloud_essd"
  system_disk_size     = 20

  install_cloud_monitor = true
}