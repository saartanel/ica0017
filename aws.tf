provider "aws" {
  profile = "default"
  region = "eu-north-1"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_traffic"
  description = "Allow inbound connections from SSH, HTTP and ICMP and Outbound allows all"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}