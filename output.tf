## Gerando outputs para os parametros do SSM Parameter Store
## outputs sao importantes para pegar valores de recursos criados em outros modulos ou arquivos
## e usar esses valores em outros modulos ou arquivos


### 
### P/ VPC ------------------------------------------------------------------------
###
output "ssm_vpc_id" {
  value = aws_ssm_parameter.vpc_parameter.id
}

###
### P/ subnets privadas -----------------------------------------------------------
###
output "ssm_subnet_private_1a" {
  value = aws_ssm_parameter.private_1a_parameter.id
}

output "ssm_subnet_private_1b" {
  value = aws_ssm_parameter.private_1b_parameter.id
}

output "ssm_subnet_private_1c" {
  value = aws_ssm_parameter.private_1c_parameter.id
}

###
### P/ subnets publicas -----------------------------------------------------------
###
output "ssm_subnet_public_1a" {
  value = aws_ssm_parameter.public_1a_parameter.id
}

output "ssm_subnet_public_1b" {
  value = aws_ssm_parameter.public_1b_parameter.id
}

output "ssm_subnet_public_1c" {
  value = aws_ssm_parameter.public_1c_parameter.id
}

###
### P/ subnets privadas de databases ----------------------------------------------
###
output "ssm_subnet_databases_1a" {
  value = aws_ssm_parameter.databases_1a_parameter.id
}

output "ssm_subnet_databases_1b" {
  value = aws_ssm_parameter.databases_1b_parameter.id
}

output "ssm_subnet_databases_1c" {
  value = aws_ssm_parameter.databases_1c_parameter.id
}