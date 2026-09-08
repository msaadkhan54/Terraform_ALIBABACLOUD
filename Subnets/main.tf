resource "alicloud_vswitch" "public-subnet-1a" {
  vswitch_name = "Pub-Sub-1a"
  cidr_block   = "10.0.1.0/24"
  vpc_id       = var.vpc_id
  zone_id      = "us-east-1a"
}

resource "alicloud_vswitch" "public-subnet-1b" {
  vswitch_name = "Pub-Sub-1b"
  cidr_block   = "10.0.2.0/24"
  vpc_id       = var.vpc_id
  zone_id      = "us-east-1b"
}

resource "alicloud_vswitch" "private-subnet-1a" {
  vswitch_name = "Pvt-Sub-1a"
  cidr_block   = "10.0.3.0/24"
  vpc_id       = var.vpc_id
  zone_id      = "us-east-1a"
}

resource "alicloud_vswitch" "private-subnet-1b" {
  vswitch_name = "Pvt-Sub-1b"
  cidr_block   = "10.0.4.0/24"
  vpc_id       = var.vpc_id
  zone_id      = "us-east-1b"
}

resource "alicloud_route_table" "public-rt" {
  vpc_id           = var.vpc_id
  route_table_name = "public-rt"
  associate_type   = "VSwitch"
}

resource "alicloud_route_table" "private-rt" {
  vpc_id           = var.vpc_id
  route_table_name = "private-rt"
  associate_type   = "VSwitch"
}

resource "alicloud_route_table_attachment" "public-1a" {
  vswitch_id     = alicloud_vswitch.public-subnet-1a.id
  route_table_id = alicloud_route_table.public-rt.id
}

resource "alicloud_route_table_attachment" "public-1b" {
  vswitch_id     = alicloud_vswitch.public-subnet-1b.id
  route_table_id = alicloud_route_table.public-rt.id
}

resource "alicloud_route_table_attachment" "private-1a" {
  vswitch_id     = alicloud_vswitch.private-subnet-1a.id
  route_table_id = alicloud_route_table.private-rt.id
}

resource "alicloud_route_table_attachment" "private-1b" {
  vswitch_id     = alicloud_vswitch.private-subnet-1b.id
  route_table_id = alicloud_route_table.private-rt.id
}

resource "alicloud_eip_address" "EIP" {
  address_name         = "S-eip"
  bandwidth            = "1"
  internet_charge_type = "PayByBandwidth"
  payment_type         = "PayAsYouGo"
}

resource "alicloud_nat_gateway" "nat" {
  vpc_id           = var.vpc_id
  nat_gateway_name = "Saad-NAT"
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.public-subnet-1a.id
  nat_type         = "Enhanced"
}

resource "alicloud_eip_association" "nat_eip_assoc" {
  allocation_id = alicloud_eip_address.EIP.id
  instance_id   = alicloud_nat_gateway.nat.id
  instance_type = "Nat"
}

resource "alicloud_route_entry" "private_nat_route" {
  route_table_id        = alicloud_route_table.private-rt.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.nat.id
}

resource "alicloud_snat_entry" "pvt_snat-1a" {
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private-subnet-1a.id
  snat_ip           = alicloud_eip_address.EIP.ip_address
}

resource "alicloud_snat_entry" "pvt_snat_1b" {
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private-subnet-1b.id
  snat_ip           = alicloud_eip_address.EIP.ip_address
}