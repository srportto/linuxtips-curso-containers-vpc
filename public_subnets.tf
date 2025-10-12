## -----------------------------------------------------------------------------
## criacao das subnets que formarao a o conjunto de rede publica da VPC
## 
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.48.0/24"
  availability_zone = format("%sa", var.region) #hack para criar a subnet na AZ da regiao em questao

  tags = {
    Name = format("%s-public-subnet-1a", var.project_name)
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.49.0/24"
  availability_zone = format("%sb", var.region) #hack para criar b subnet na AZ da regiao em questao

  tags = {
    Name = format("%s-public-subnet-1b", var.project_name)
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.50.0/24"
  availability_zone = format("%sc", var.region) #hack para criar c subnet na AZ da regiao em questao

  tags = {
    Name = format("%s-public-subnet-1c", var.project_name)
  }
}

## -----------------------------------------------------------------------------
## Criando a Router table direcionar o acesso das subnets do conjunto publico - sair para internet via internet gateway (bidirecional: entra e sai)
## -----------------------------------------------------------------------------
resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-public", var.project_name)
  }

}

##-----------------------------------------------
##Criando a rota p/ acesso a internet(bidirecional: entra e sai)
##-----------------------------------------------

resource "aws_route" "public_access" {
  route_table_id         = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"

  #vinculando o internet gateway a rota para possibilitar acesso a internet(bidirecional: entra e sai ou seja, acesso publico)
  gateway_id             = aws_internet_gateway.igw.id
}


## ----------------------------------------------
## Mapeamento/associaçao das subnets publicas para a route table com acesso a internet(bidirecional: entra e sai)
## ----------------------------------------------
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_internet_access.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_internet_access.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_internet_access.id
}