
/// VPC

variable "profile" {
  type        = string
  default     = "Terraboy"
  description = "profile"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr_block"
}


variable "enable_dns" {
  type        = bool
  default     = true
  description = "Enables DNS hostname"
}



variable "public_cidr_block" {
  type        = string
  default     = "10.0.192.0/19"
  description = "cidr block for public subnet"
}


variable "availability_zone_a" {
  type        = string
  default     = "ca-central-1a"
  description = "Availability zone of the server."
}

variable "availability_zone_b" {
  type        = string
  default     = "ca-central-1b"
  description = "Availability zone of the server."
}


variable "map_public_ip" {
  type        = bool
  default     = true
  description = "Enables DNS hostname"
}

variable "private_cidr_block" {
  type        = string
  default     = "10.0.224.0/20"
  description = "cidr block for private subnet"
}


variable "map_private_ip" {
  type        = bool
  default     = false
  description = "Disables DNS hostname"
}

variable "private_cidr_block_b" {
  type        = string
  default     = "10.0.248.0/21"
  description = "cidr block for private subnet"
}

variable "destination_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Destination cidr"
}

variable "region" {
  default     = "ca-central-1"
  description = "AWS region"
}

variable "port" {
  type        = number
  default     = 80
  description = "Port"
}

variable "ssh_port" {
  type        = number
  default     = 22
  description = "Port"
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "Protocol"
}

variable "egress_port" {
  type        = number
  default     = 0
  description = "Protocol"
}


/// Ec2 Varibles

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type of the server."
}

variable "key_pair" {
  type        = string
  default     = "~/.ssh/videri_key.pub"
  description = "ssh-key"
}

variable "key_name" {
  type        = string
  default     = "videri_key"
  description = "key name"
}

variable "public_ip_address" {
  type        = bool
  default     = true
  description = "asociate public ip"
}



/// RDS VARIABLES


variable "db_password" {
  description = "RDS root user password"
  default     = "master123"
  sensitive   = true
}

variable "rds_name" {
  default     = "shola"
  description = "RDS name"
}

variable "db_name" {
  default     = "shola"
  description = "RDS name"
}


variable "rds_port" {
  default     = "5432"
  description = "RDS port"
}

variable "rds_protocol" {
  default     = "tcp"
  description = "RDS protocol"
}

variable "instance_class" {
  default     = "db.t3.micro"
  description = "RDS class"
}

variable "allocated_storage" {
  type        = number
  default     = 5
  description = "RDS storage"
}

variable "engine" {
  default     = "postgres"
  description = "RDS engine"
}

variable "engine_version" {
  default     = "13.7"
  description = "RDS engine version"
}

variable "cidr_blocks" {
  type        = string
  default     = "0.0.0.0/0"
  description = "cidr block"
}


variable "family_parameter" {
  type        = string
  default     = "postgres13"
  description = "family parameter"
}

variable "log_name" {
  type        = string
  default     = "log_connections"
  description = "log"
}

variable "parameter_value" {
  type    = string
  default = "1"
}

variable "public_access" {
  type        = bool
  default     = false
  description = "accessibilty"
}
