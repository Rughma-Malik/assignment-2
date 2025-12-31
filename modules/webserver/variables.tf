variable "env_prefix" {
  type        = string
  description = "Environment prefix (e.g., prod, dev)"
}

variable "instance_name" {
  type        = string
  description = "Name tag for the instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "availability_zone" {
  type        = string
  description = "AWS Availability Zone"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID to attach"
}

variable "public_key" {
  type        = string
  description = "Path to the public key file"
}

variable "script_path" {
  type        = string
  description = "Path to the bash script for user_data"
}

variable "instance_suffix" {
  type        = string
  description = "Unique suffix for resources like Key Pairs"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
}