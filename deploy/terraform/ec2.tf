data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "demo" {
  name        = "${local.name_prefix}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id
  tags        = local.tags

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  user_data = <<-EOT
              #!/bin/bash
              set -euxo pipefail
              dnf update -y
              dnf install -y nginx
              echo "<h1>${local.name_prefix} demo instance</h1>" > /usr/share/nginx/html/index.html
              systemctl enable --now nginx
              EOT
}

resource "aws_instance" "demo" {
  count                       = var.enable_instance ? 1 : 0
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids      = [aws_security_group.demo.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_demo.name
  associate_public_ip_address = true
  user_data                   = local.user_data
  tags                        = merge(local.tags, { Name = "${local.name_prefix}-instance" })
}


