variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.0.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  default     = "eu-west-3a"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  default     = "ami-0ff71843f814379b3"
}

variable "ssh_key_name" {
  description = "Name for the SSH key pair"
  default     = "ychibani"
}

variable "ssh_user" {
  description = "SSH user for EC2 connection"
  default     = "ubuntu"
}

variable "secret_name" {
  description = "Name of the secret in AWS Secrets Manager"
  default     = "inception-env"
}


variable "local_private_key_path" {
  description = "Chemin local vers le fichier .pem correspondant à la clé AWS"
  type        = string
  default     = "../keys"
}
