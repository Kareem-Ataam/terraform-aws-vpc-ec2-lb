module "web-vpc" {
  source               = "./modules/vpc"
  vpc_cidr_block       = var.vpc_cidr_block
  env-prefix           = var.env-prefix
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  subnet_cidr_blocks   = var.subnet_cidr_blocks
  avail_zones          = var.avail_zones
  subnet_names         = var.subnet_names
  map_pub_ip           = var.map_pub_ip
}
###########################################################
locals {
  vpc_id = module.web-vpc.vpc_id
}
###########################################################
resource "aws_route_table_association" "rt-assoc-public" {
  subnet_id      = module.web-vpc.subnet_info[0]
  route_table_id = module.web-vpc.public_RT_id
}
resource "aws_route_table_association" "rt-assoc-private-1" {
  subnet_id      = module.web-vpc.subnet_info[1]
  route_table_id = module.web-vpc.private_RT_id
}
resource "aws_route_table_association" "rt-assoc-private-2" {
  subnet_id      = module.web-vpc.subnet_info[2]
  route_table_id = module.web-vpc.private_RT_id
}
#############################################################
module "instances" {
  source               = "./modules/ec2-instance"
  my_ip                = var.my_ip
  ami_list             = var.ami_list
  instance_types       = var.instance_types
  public_key_path      = var.public_key_path
  user_data_file_paths = var.user_data_file_paths
  vpc_id               = module.web-vpc.vpc_id
  subnet_info          = module.web-vpc.subnet_info
  instance_names       = var.instance_names
}
