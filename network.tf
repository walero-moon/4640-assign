# Create a new vpc
resource "digitalocean_vpc" "lab_vpc" {
  name   = "ACIT4640"
  region = var.region
}