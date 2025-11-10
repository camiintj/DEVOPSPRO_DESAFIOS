# Security Group para o EKS

resource "aws_security_group" "eks" {
    name        = "${var.environment}-eks-sg"
    description = "Security group do EKS"
    vpc_id      = aws_vpc.main.id

    tags = merge(var.tags,{
        Name           = "${var.environment}-eks-sg"
    })
}

resource "aws_security_group_rule" "eks_ingress_https" {
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "-1"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = aws_security_group.eks.id
    description              = "Permite o trafego HTTPS para o EKS"
}

resource "aws_security_group_rule" "eks_ingress_internal" {
    type                     = "ingress"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    self = true
    security_group_id        = aws_security_group.eks.id
    description              = "Permite o trafego interno entre os recursos do EKS"
}

resource "aws_security_group_rule" "eks_egress" {
    type                     = "egress"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = aws_security_group.eks.id
    description              = "Permite o trafego de saida"
}




# Security Group para o RDS

resource "aws_security_group" "rds" {
    name        = "${var.environment}-rds-sg"
    description = "Security group do RDS"
    vpc_id      = aws_vpc.main.id

    tags = merge(var.tags,{
        Name           = "${var.environment}-rds-sg"
    })
}

resource "aws_security_group_rule" "rds_ingress_postgres" {
    type                     = "ingress"
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    cidr_blocks              = aws_subnet.rds_private[*].cidr_block
    security_group_id        = aws_security_group.rds.id
    description              = "Permite acesso ao Postgres"
}

resource "aws_security_group_rule" "rds_egress" {
    type                     = "egress"
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = aws_security_group.rds.id
    description              = "Permite o trafego de saida"
}