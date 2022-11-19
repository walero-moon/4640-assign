terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

#Configure the Digital cean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a new tag
resource "digitalocean_tag" "lab_tag" {
  name = "Lab"
}

resource "digitalocean_project" "assignment_project" {
  name        = "4640Assignment"
  description = "ACIT 4640 Lab from Week 7"
  purpose     = "School/Education"
  environment = "Development"
}

resource "digitalocean_project_resources" "assignment_project_resources" {
  project = digitalocean_project.assignment_project.id

  resources = flatten([
    digitalocean_droplet.lab_droplet.*.urn,
    digitalocean_droplet.bastion.*.urn,
    digitalocean_loadbalancer.public.*.urn,
    digitalocean_database_cluster.mongodb.*.urn,
  ])
}