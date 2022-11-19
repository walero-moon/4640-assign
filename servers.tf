# Create a new droplet
resource "digitalocean_droplet" "lab_droplet" {
  image    = "ubuntu-20-04-x64"
  count    = var.droplet_count
  name     = "lab-${count.index + 1}"
  tags     = [digitalocean_tag.lab_tag.id]
  region   = var.region
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.lab_vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

# Droplet firewall
resource "digitalocean_firewall" "lab" {
  # Name of the firewall
  name        = "lab-firewall"
  droplet_ids = digitalocean_droplet.lab_droplet.*.id

  # Internal VPC Rules. We have to let ourselves talk to each other
  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  # Selective Outbound Traffic Rules

  # HTTP
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # HTTPS
  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # ICMP
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # DNS
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}


# Load balancer
resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_tag = "Lab"
  vpc_uuid    = digitalocean_vpc.lab_vpc.id
}