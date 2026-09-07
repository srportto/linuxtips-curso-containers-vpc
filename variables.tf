#### General configs ####
variable "project_name" {
  type        = string
  description = "Nome do projeto, usado como prefixo/tag em todos os recursos da VPC."
}

variable "region" {
  type        = string
  description = "Região AWS onde a VPC e seus recursos serão provisionados."
}
