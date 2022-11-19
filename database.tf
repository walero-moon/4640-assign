# Make a tiny MongoDB server
resource "digitalocean_database_cluster" "mongodb" {
  name       = "lab-mongodb-cluster"
  engine     = "mongodb"
  version    = "4.4"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = var.database_node_count

  # Attach to VPC
  private_network_uuid = digitalocean_vpc.lab_vpc.id
}

# Firewall 
resource "digitalocean_database_firewall" "mongodb" {
  cluster_id = digitalocean_database_cluster.mongodb.id

  rule {
    type  = "tag"
    value = digitalocean_tag.lab_tag.id
  }

  # Necessary to allow entry through MongoDB Compass
  rule {
    type  = "ip_addr"
    value = var.your_ip
  }
}