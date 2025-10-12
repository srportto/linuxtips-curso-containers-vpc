## -----------------------------------------------------------------------------
## criacao das subnets que formarao a o conjunto de rede privada da VPC, mas que terao acesso a internet via nat gateway apenas de saida (unidirecional: so sai)
## 
resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = format("%sa", var.region) #hack para criar a subnet na AZ da regiao em questao

  tags = {
    Name = format("%s-private-subnet-1a", var.project_name)
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = format("%sb", var.region) #hack para criar b subnet na AZ da regiao em questao

  tags = {
    Name = format("%s-private-subnet-1b", var.project_name)
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = format("%sc", var.region) #hack para criar c subnet na AZ da regiao em questao

  tags = {
    Name = format("%s-private-subnet-1c", var.project_name)
  }
}

## -----------------------------------------------------------------------------
## Criando as Routers tables para direcionar acesso das subnets do conjunto privado - sair para internet via natGateway(unidirecional: so sai)
## -----------------------------------------------------------------------------
resource "aws_route_table" "private_internet_access_1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-private-1a", var.project_name)
  }

}

resource "aws_route_table" "private_internet_access_1b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-private-1b", var.project_name)
  }

}

resource "aws_route_table" "private_internet_access_1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-private-1c", var.project_name)
  }

}



## ----------------------------------------------
## Criando as rotas p/ acesso a internet(unidirecional: so sai, ou seja, acesso privado) para o rotetable de cada subnet privada
## ----------------------------------------------

resource "aws_route" "private_access_1a" {
  route_table_id         = aws_route_table.private_internet_access_1a.id
  destination_cidr_block = "0.0.0.0/0"

  #vinculando o Nat gateway a rota para possibilitar acesso a internet(unidirecional: so sai, ou seja, acesso privado)
  gateway_id             = aws_nat_gateway.ngw_1a.id
}


resource "aws_route" "private_access_1b" {
  route_table_id         = aws_route_table.private_internet_access_1b.id
  destination_cidr_block = "0.0.0.0/0"

  #vinculando o Nat gateway a rota para possibilitar acesso a internet(unidirecional: so sai, ou seja, acesso privado)
  gateway_id             = aws_nat_gateway.ngw_1b.id
}


resource "aws_route" "private_access_1c" {
  route_table_id         = aws_route_table.private_internet_access_1c.id
  destination_cidr_block = "0.0.0.0/0"
  #vinculando o Nat gateway a rota para possibilitar acesso a internet(unidirecional: so sai, ou seja, acesso privado)
  gateway_id             = aws_nat_gateway.ngw_1c.id
}



# ----------------------------------------------
## Mapeamento/associaçao das subnets privadas para a route table com acesso a internet(unidirecional: so sai, ou seja, acesso privado)
## ----------------------------------------------
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_internet_access_1a.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_internet_access_1b.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.private_internet_access_1c.id
}