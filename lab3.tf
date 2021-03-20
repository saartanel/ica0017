# Create sec group for ssh, http and icmp
resource "aws_security_group" "allow_ports" {
  name        = "allow_traffic"
  description = "Allow inbound connections from SSH, HTTP and ICMP and Outbound allows all"
  vpc_id      = var.vpc

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ports"
  }
}


# Create key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "tanelsaar"
  public_key = tls_private_key.this.public_key_openssh
  tags = {
    tag-key = "tanelsaar"
  }
}


# Create instance
resource "aws_instance" "web" {
  ami           = "ami-068509dbe82d01c91"
  instance_type = "t3.micro"
  key_name = "tanelsaar"
  iam_instance_profile = "S3_Access"

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                touch /var/www/html/index.html
                echo "tanelsaar" >> /var/www/html/index.html
                sudo service httpd enable
                sudo service httpd start
                EOF

  tags = {
    Name = "tanelsaar"
  }
}

# Assign security group to instance interface
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.allow_ports.id
  network_interface_id = aws_instance.web.primary_network_interface_id
}

# Create ami from instance

resource "aws_ami_from_instance" "my_ami" {
  name               = "my_ami"
  source_instance_id = aws_instance.web.id
}

