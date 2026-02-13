variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Named AWS CLI profile to use for auth"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Short name used to tag and name resources"
  type        = string
  default     = "meridian-demo"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "enable_instance" {
  description = "Whether to create the EC2 demo instance"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for demo"
  type        = string
  default     = "t3.micro"
}


