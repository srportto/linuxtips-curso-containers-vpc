resource "aws_ssm_parameter" "vpc_parameter" {
  name = format("/%s/vpc/vpc_id", var.project_name)
  type = "String"
  value = aws_vpc.main.id  
}

## P/ subnets privadas 
resource "aws_ssm_parameter" "private_1a_parameter" {
  name = format("/%s/vpc/subnet_private_1a", var.project_name)
  type = "String"
  value = aws_subnet.private_subnet_1a.id
}

resource "aws_ssm_parameter" "private_1b_parameter" {
  name = format("/%s/vpc/subnet_private_1b", var.project_name)
  type = "String"
  value = aws_subnet.private_subnet_1b.id
}

resource "aws_ssm_parameter" "private_1c_parameter" {
  name = format("/%s/vpc/subnet_private_1c", var.project_name)
  type = "String"
  value = aws_subnet.private_subnet_1c.id
}

## P/ subnets publicas
resource "aws_ssm_parameter" "public_1a_parameter" {
  name = format("/%s/vpc/subnet_public_1a", var.project_name)
  type = "String"
  value = aws_subnet.public_subnet_1a.id
}

resource "aws_ssm_parameter" "public_1b_parameter" {
  name = format("/%s/vpc/subnet_public_1b", var.project_name)
  type = "String"
  value = aws_subnet.public_subnet_1b.id
}

resource "aws_ssm_parameter" "public_1c_parameter" {
  name = format("/%s/vpc/subnet_public_1c", var.project_name)
  type = "String"
  value = aws_subnet.public_subnet_1c.id
}

## P/ subnets privada de databases
resource "aws_ssm_parameter" "databases_1a_parameter" {
  name = format("/%s/vpc/subnet_databases_1a", var.project_name)
  type = "String"
  value = aws_subnet.databases_subnet_1a.id
}

resource "aws_ssm_parameter" "databases_1b_parameter" {
  name = format("/%s/vpc/subnet_databases_1b", var.project_name)
  type = "String"
  value = aws_subnet.databases_subnet_1b.id
}

resource "aws_ssm_parameter" "databases_1c_parameter" {
  name = format("/%s/vpc/subnet_databases_1c", var.project_name)
  type = "String"
  value = aws_subnet.databases_subnet_1c.id
}