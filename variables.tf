variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation being /22 or greater, from which to assign client IP addresses"
  default = "18.0.0.0/22"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to associate with the Client VPN endpoint."
}

variable "server_certs" {
  type = any
}

variable "clients_certs" {
  type = any
}

variable "domain_name" {
  default = "example.net"
  type = string
}