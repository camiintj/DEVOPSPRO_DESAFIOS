# Create VPC

resource "aws_vpc" "main" {
  
  cidr_block = var.vpc_cidr
  tags = merge(var.tags,{
    Name = "${var.environment}-vpc"
  })
}




# Create Subnets - Public and Private for EKS and RDS

resource "aws_subnet" "eks_public" {

    count                   = length(var.public_subnet)                  //cria uma sub-rede para cada CIDR na lista
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet[count.index]
    availability_zone       = var.availability_zones[count.index]       //atribui uma zona de disponibilidade correspondente
    map_public_ip_on_launch = true                                      //designa um IP público automaticamente

    tags = merge(var.tags,{
        Name = "${var.environment}-public-subnet-${count.index + 1}"
        "kubernetes.io/role/elb" = 1                                     //marca a sub-rede para uso com ELBs        
    })
}

resource "aws_subnet" "eks_private" {

    count                   = length(var.eks_private_subnet)              
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.eks_private_subnet[count.index]
    availability_zone       = var.availability_zones[count.index]        
                                       

    tags = merge(var.tags,{
        Name = "${var.environment}-private-eks-subnet-${count.index + 1}"
        "kubernetes.io/role/internal-elb" = 1                              //marca a sub-rede para uso com ELBs - Internal para rede privada
    })
}

resource "aws_subnet" "rds_private" {

    count                   = length(var.rds_private_subnet)                
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.rds_private_subnet[count.index]
    availability_zone       = var.availability_zones[count.index]            
                                       

    tags = merge(var.tags,{
        Name = "${var.environment}-private-rds-subnet-${count.index + 1}"
    })
}




# Create Internet Gateway - Public Subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags,{
    Name = "${var.environment}-igw"
  })
}




# Create Elastic IPs and NAT Gateways - Private Subnets
resource "aws_eip" "eip_nat" {
    count = length(var.public_subnet)
    domain   = "vpc"

    tags = merge(var.tags,{
        Name = "${var.environment}-nat-eip-${count.index + 1}"
    })
}


resource "aws_nat_gateway" "nat" {

    count                   = length(var.public_subnet)
    allocation_id           = aws_eip.eip_nat[count.index].id
    subnet_id               = aws_subnet.eks_public[count.index].id

    tags = merge(var.tags,{
        Name = "${var.environment}-nat-gateway-${count.index + 1}"
    })

    depends_on = [aws_internet_gateway.gw]
}



# Create Route Tables and Routes

resource "aws_route_table" "public_rt" {
  vpc_id        = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags,{
        Name        = "${var.environment}-public-rt"
    })
  
}

resource "aws_route_table" "eks_private_rt" {
  vpc_id               = aws_vpc.main.id
  count               = length(var.eks_private_subnet)

  route {
    cidr_block         = "0.0.0.0/0"
    gateway_id         = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(var.tags,{
        Name           = "${var.environment}-eks-private-rt"
    })
  
}

resource "aws_route_table" "rds_private_rt" {
  vpc_id               = aws_vpc.main.id
  count               = length(var.rds_private_subnet)

  route {
    cidr_block         = "0.0.0.0/0"
    gateway_id         = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(var.tags,{
        Name           = "${var.environment}-rds-private-rt"
    })
  
}



# Associate Route Tables with Subnets

resource "aws_route_table_association" "public" {
    count         = length(var.public_subnet)
    subnet_id      = aws_subnet.eks_public[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "eks_private" {
    count         = length(var.eks_private_subnet)
    subnet_id      = aws_subnet.eks_private[count.index].id
    route_table_id = aws_route_table.eks_private_rt[count.index].id
}

resource "aws_route_table_association" "rds_private" {
    count         = length(var.rds_private_subnet)
    subnet_id      = aws_subnet.rds_private[count.index].id
    route_table_id = aws_route_table.rds_private_rt[count.index].id
}