variable "region" {
 type        = string
 description = "Define Region For Build Aws Infra"
 default = "ap-south-1"
}

variable "access_key" {
    type     = string
    description = "Define Access Key" 
    default = "AKIAREZ3IG4O3LUIUPPD" 
}

variable "secret_key" {
  type       = string
  description = "Define Secret Key"
  default = "KEwaFt+jTEJwz5Ho+b+wqimmg6rZBUHoCTyTT98t"
}

variable "instance_ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-074dc0a6f6c764218"
}

variable "instance_type" {
  type        = string
  description = "Define Instance Type"
  default     = "t2.micro"
}

variable "vpc_cidr_block" {
     type  =  string
     description = "Define Vpc Cidr Block"
     default = "10.0.0.0/16"
}

variable "vpc_subnet_cidr" { 
    type = list
    description = " Define Subnet1 Cidr Block "
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}
