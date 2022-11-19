# Print IP address of new droplet
output "droplets_public_ip_address" {
  value = flatten([digitalocean_droplet.lab_droplet.*.ipv4_address])
}

# Print private IP Address of droplet
output "droplets_private_ip_address" {
  value = flatten([digitalocean_droplet.lab_droplet.*.ipv4_address_private])
}

# Print IP address of bastion
output "bastion_ip_address" {
  value = flatten([digitalocean_droplet.bastion.*.ipv4_address])
}

# Print IP address of Database
output "database_ip_address" {
  value = flatten([digitalocean_database_cluster.mongodb.*.urn])
}

# !!! WARNING, THIS WILL OUTPUT THE PASSWORD OF THE DATABASE TO THE TERMINAL !!!
# Print password of Database
output "database_password" {
  sensitive = true
  value     = flatten([digitalocean_database_cluster.mongodb.*.password])
}

# Print IP address of Load Balancer
output "loadbalancer_ip_address" {
  value = [digitalocean_loadbalancer.public.ip]
}