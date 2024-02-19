variable "my_ip" {
  type        = string
  description = "Your public IP address"
}
variable "ami_list" {
  type = list(string)
}
variable "instance_types" {
  type = list(string)
}
variable "public_key_path" {
  type = string
}
variable "user_data_file_paths" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}
variable "subnet_info" {
  type = list(string)
}
variable "instance_names" {
  type = list(string)
}
