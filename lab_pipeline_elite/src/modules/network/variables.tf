variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "environment" {
  type = string
  description = "Nome do ambiente"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  
}

variable "availability_zones" {
    type = list(string)
    description = "Lista de zonas de disponibilidade"
  
} 

variable "public_subnet" {
    type = list(string)
    description = "Lista de CIDR das sub-redes públicas"
  
}

variable "eks_private_subnet" {
    type = list(string)
    description = "Lista de CIDR das sub-redes privadas do EKS"
}

variable "rds_private_subnet" {
    type = list(string)
    description = "Lista de CIDR das sub-redes privadas do RDS"
}