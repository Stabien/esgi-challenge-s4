terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "easynight-terraform-state-bucket"
    key            = ":env/production/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_credentials.access_key
  secret_key = var.aws_credentials.secret_key
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Security group for example_server"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Autoriser l'accès depuis n'importe quelle adresse IP
  security_group_id = aws_security_group.example_sg.id
}

resource "aws_security_group_rule" "allow_server_connection" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Autoriser l'accès depuis n'importe quelle adresse IP
  security_group_id = aws_security_group.example_sg.id
}

resource "aws_instance" "example_server" {
  ami           = var.aws_instance.ami
  instance_type = var.aws_instance.instance_type
  key_name = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true
  security_groups = [aws_security_group.example_sg.name]
}

output "domain_name" {
  value = aws_instance.example_server.public_dns
}

resource "null_resource" "ssh_to_docker_container" {
  connection {
    type        = "ssh"
    host        = aws_instance.example_server.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    content     = var.git_ssh_key
    destination = "/tmp/id_rsa"
  }

  provisioner "file" {
    source = "./scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    content = <<-EOT
      DB_HOST=${var.db_config.host}
      DB_PORT=${var.db_config.port}
      DB_USERNAME=${var.db_config.username}
      DB_PASSWORD=${var.db_config.password}
      DB_NAME=${var.db_config.name}
      PORT=${var.server_port}
      JWT_SECRET=${var.jwt_secret}
    EOT

    destination = "/tmp/.env.local"
  }

  provisioner "remote-exec" {
    inline = [ 
      "cd /tmp",
      "chmod 777 ./install.sh",
      "./install.sh",
    ]
  }

  depends_on = [ aws_instance.example_server ]
}

output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.example_server.public_ip
}

output "ec2_username" {
  description = "The username for SSH access"
  value       = "ubuntu"  # Assurez-vous que ce nom d'utilisateur correspond à votre instance AMI
}

output "ec2_port" {
  description = "The SSH port"
  value       = 22
}