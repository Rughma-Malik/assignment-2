variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "The vpc_cidr_block must be a valid CIDR notation."
  }
}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for the Subnet"
  default     = "10.0.10.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr_block, 0))
    error_message = "The subnet_cidr_block must be a valid CIDR notation."
  }
}

variable "availability_zone" {
  type        = string
  description = "AWS Availability Zone"
  default     = "me-central-1a"
}

variable "env_prefix" {
  type        = string
  description = "Prefix for environment resources (e.g., dev, prod)"
  default     = "prod"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t3.micro"
}

variable "public_key" {
  type        = string
  description = "Path to the public SSH key"
}

variable "private_key" {
  type        = string
  description = "Path to the private SSH key"
}

# The backend_servers variable is technically defined in locals as per the prompt instructions for 1.5,
# but if you wish to pass it as a variable, define it here. 
# For this assignment, 1.5 strictly asks to define the list in locals.tf.