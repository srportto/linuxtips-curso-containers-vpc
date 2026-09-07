# Incoerências encontradas — infra VPC (Terraform)

Análise dos arquivos `.tf` na raiz do repo (`backend.tf`, `providers.tf`, `vpc.tf`,
`internet_gateway.tf`, `nat_gateway.tf`, `public_subnets.tf`, `private_subnets.tf`,
`databases_subnets.tf`, `parameters_store.tf`, `output.tf`, `variables.tf`).

## 1. Bug — rota privada usa `gateway_id` em vez de `nat_gateway_id`

**Arquivo:** `private_subnets.tf:70-93`

```hcl
resource "aws_route" "private_access_1a" {
  route_table_id         = aws_route_table.private_internet_access_1a.id
  destination_cidr_block = "0.0.0.0/0"

  #vinculando o Nat gateway a rota para possibilitar acesso a internet(unidirecional: so sai, ou seja, acesso privado)
  gateway_id             = aws_nat_gateway.ngw_1a.id
}
```

O mesmo padrão se repete em `private_access_1b` e `private_access_1c`. O atributo
`gateway_id` do recurso `aws_route` espera um Internet Gateway ou Virtual Private
Gateway (`igw-*`/`vgw-*`); um NAT Gateway (`nat-*`) deve ser referenciado via
`nat_gateway_id`. Como está, o `apply` deve falhar (ou, na melhor hipótese, a rota
fica inconsistente), quebrando a saída de internet das subnets privadas.

## 2. Subnets de databases sem route table associada

**Arquivo:** `databases_subnets.tf`

Diferente de `public_subnets.tf` e `private_subnets.tf`, as subnets
`databases_subnet_1a/1b/1c` não têm nenhum `aws_route_table` nem
`aws_route_table_association` dedicados. Elas ficam implicitamente presas à *main
route table* da VPC (padrão da AWS), que não é gerenciada explicitamente em nenhum
arquivo deste módulo. O isolamento de rede do tier de banco de dados fica dependendo
de um comportamento implícito e não documentado, em vez de uma decisão explícita
(rota isolada, sem saída para internet).

## 3. Subnets públicas sem `map_public_ip_on_launch`

**Arquivo:** `public_subnets.tf:4-32`

Nenhuma das subnets `public_subnet_1a/1b/1c` define
`map_public_ip_on_launch = true`. Mesmo estando associadas a uma route table com
saída via Internet Gateway, instâncias criadas nelas sem IP público explícito na
interface de rede não terão IP público automaticamente — comportamento inesperado
para o que o nome/comentário do arquivo ("conjunto de rede pública da VPC") sugere.

## 4. NAT Gateway sem `depends_on` do Internet Gateway

**Arquivo:** `nat_gateway.tf:38-63`

Os recursos `aws_nat_gateway.ngw_1a/1b/1c` não têm `depends_on` para
`aws_internet_gateway.igw`. A AWS recomenda essa dependência explícita porque o NAT
Gateway só funciona corretamente depois que o Internet Gateway da VPC já existe, e
o Terraform não infere essa relação automaticamente (não há referência direta entre
os dois recursos), podendo causar falha intermitente de provisionamento em `apply`
do zero.

## 5. Nenhum `versions.tf` / `required_providers`

Assim como no repo `ecs-cluster`, não há pin de versão do provider AWS nem
`required_version` do Terraform em nenhum arquivo do módulo (`providers.tf` só
define a região). Risco de quebra silenciosa em upgrade de provider.

## 6. `variables.tf` sem tipo, descrição ou default

**Arquivo:** `variables.tf`

```hcl
variable "project_name" {}
variable "region" {}
```

As duas variáveis usadas em todo o módulo (`project_name`, `region`) não têm
`type`, `description` nem `default`/validação. Sem contrato explícito, um valor
incorreto (ex.: região mal formatada) só é percebido em tempo de `apply`, não de
`plan`/`validate`.

## 7. Três NAT Gateways (um por AZ) — custo elevado, sem alternativa documentada

**Arquivos:** `nat_gateway.tf`, `private_subnets.tf`

Não é um bug, mas é uma decisão de custo relevante: cada NAT Gateway cobra por hora
+ por GB processado, e o módulo cria um por AZ (3 no total) incondicionalmente, sem
variável para reduzir a 1 NAT Gateway compartilhado em ambientes não produtivos
(padrão comum para dev/homolog). Candidato a virar parametrizável
(`var.single_nat_gateway` ou similar).
