# Security group for the instance in the public subnet
resource "aws_security_group" "public-sg" {
  name        = "Nginx-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = "Nginx-sg"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_security_group" "private-sg" {
  name        = "Apache-sg"
  description = "Allow traffic from the laod balancer (nginx)"
  vpc_id      = var.vpc_id
  tags = {
    Name = "Apache-sg"
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public-sg.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public-sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
#SSH Login Key pair
resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = file(var.public_key_path)
}
#------------------------------End of Security Groups ----------------------------
resource "aws_instance" "server" {
  count                  = length(var.ami_list)
  ami                    = var.ami_list[count.index]
  instance_type          = var.instance_types[count.index]
  key_name               = aws_key_pair.ssh-key.key_name
  subnet_id              = var.subnet_info[count.index]
  vpc_security_group_ids = count.index == 0 ? [aws_security_group.public-sg.id] : [aws_security_group.private-sg.id]
  user_data              = file(var.user_data_file_paths[count.index])
  tags = {
    Name = var.instance_names[count.index]
  }
}
