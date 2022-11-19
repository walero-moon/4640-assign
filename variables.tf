variable "do_token" {
  description = "Digital Ocean API Token"
  type        = string
}

# Set default region
variable "region" {
  type    = string
  default = "sfo3"
}

variable "droplet_count" {
  type    = number
  default = 2
}

variable "database_node_count" {
  type    = number
  default = 1
}
variable "your_ip" {
  type    = string
  default = ""
}