## -----------------------------------------------------------------------------
## Criando os ips elastico de cada natGateway
## -----------------------------------------------------------------------------

## todo NatGateway precisa de um "elastic-ip" por isso estamos criando um abaixo
resource "aws_eip" "vpc_eip_1a" {

  domain = "vpc"
  tags = {
    Name = format("%s-eip-1a", var.project_name)
  }

}

resource "aws_eip" "vpc_eip_1b" {

  domain = "vpc"
  tags = {
    Name = format("%s-eip-1b", var.project_name)
  }

}

resource "aws_eip" "vpc_eip_1c" {

  domain = "vpc"
  tags = {
    Name = format("%s-eip-1c", var.project_name)
  }

}

## -----------------------------------------------------------------------------
## Criando natgateway (um em cada az)
## -----------------------------------------------------------------------------

## Criando o natGateway , lembrando que o ideal eh um por az 
resource "aws_nat_gateway" "ngw_1a" {
  allocation_id = aws_eip.vpc_eip_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = format("%s-ngw-1a", var.project_name)
  }
}

resource "aws_nat_gateway" "ngw_1b" {
  allocation_id = aws_eip.vpc_eip_1b.id
  subnet_id     = aws_subnet.public_subnet_1b.id

  tags = {
    Name = format("%s-ngw-1b", var.project_name)
  }
}

resource "aws_nat_gateway" "ngw_1c" {
  allocation_id = aws_eip.vpc_eip_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id

  tags = {
    Name = format("%s-ngw-1c", var.project_name)
  }
}