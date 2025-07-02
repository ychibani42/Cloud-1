#
##      --- Réseau : VPC, sous-réseau, Internet Gateway, Route Table ---
#

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Cloud-1 VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Cloud-1 IGW"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "Cloud-1 Public Subnet"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name =  "Cloud-1 Route Table"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

# --- (SSH, HTTP, HTTPS) ---
resource "aws_security_group" "security_group" {
  name        = "cloud-1_web_sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.vpc.id

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
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Cloud-1 Security Group" }
}

# --- Instance EC2 ---
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = true

  tags = { 
    Name = "Cloud-1 EC2" 
    }
}

# --- elastic IP ---
resource "aws_eip" "web" {
  instance   = aws_instance.web.id
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "null_resource" "ansible_provision" {
  depends_on = [aws_instance.web]

  # Wait for SSH to become available
  provisioner "local-exec" {
    command = <<-EOT
      until nc -zv ${aws_eip.web.public_ip} 22; do 
        echo "Waiting for SSH..."; 
        sleep 5; 
      done
    EOT
  }

  # Execute Ansible after SSH is ready
  provisioner "local-exec" {
    command     = "ANSIBLE_SSH_COMMON_ARGS='-o StrictHostKeyChecking=accept-new' ansible-playbook -i ../ansible/inventory/inventory.ini ../ansible/playbooks/playbook.yml"
    working_dir = path.module
  }
}
