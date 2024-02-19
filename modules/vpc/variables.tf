variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the VPC"
}
variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "List of the subnet CIDR blocks"
}
variable "avail_zones" {
  type        = list(string)
  description = "List of the subnet AZs"
}
variable "subnet_names" {
  type        = list(string)
  description = "List of the subnet names"
}
variable "map_pub_ip" {
  type        = list(bool)
  description = "List of boolen values specifying wheather a public IP address should be assigned automatically to each instance in the subent or not"
}
variable "env-prefix" {}
variable "enable_dns_support" {
  type = bool
}
variable "enable_dns_hostnames" {
  type = bool
}
