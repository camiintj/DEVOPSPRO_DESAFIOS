variable "environment" {
  type        = string
  description = "Nome do ambiente"
}

variable "db_name" {
  type        = string
  description = "Nome do banco de dados"
}

variable "db_username" {
    type        = string
    description = "Nome do usuário do banco de dados"
}

variable "db_password" {
    type        = string
    description = "Senha do usuário do banco de dados"
    sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  
}

variable "subnet_ids" {
    type        = list(string)
    description = "Lista de IDs das sub-redes privadas do RDS"
}

variable "security_group_ids" {
    type        = list(string)
    description = "Lista de IDs dos security groups do RDS"  
}