# Create a bastion server
resource "digitalocean_droplet" "bastion" {
  image    = "ubuntu-20-04-x64"
  name     = "bastion-${var.region}"
  region   = var.region
  tags     = [digitalocean_tag.lab_tag.id]
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.lab_vpc.id
}

# Firewall for bastion server
resource "digitalocean_firewall" "bastion" {
  # firewall name
  name = "ssh-bastion-firewall"

  # Droplets to apply the firewall to
  droplet_ids = [digitalocean_droplet.bastion.id]

  # Inbound rules
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound rules
  outbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    destination_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }

  # ICMP ping
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.lab_vpc.ip_range]
  }
}