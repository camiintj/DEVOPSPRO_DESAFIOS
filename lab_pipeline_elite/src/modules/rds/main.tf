resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "main" {
  
  identifier = "${var.environment}-postgre"
  engine                = "postgres"
  engine_version        = "17.4"
  instance_class        = "db.t3.micro"
  
  allocated_storage     = 10
  max_allocated_storage = 10
  port                  = 5432


  db_name               = var.db_name
  //manage_master_user_password = true                        // Gerencia a senha do usuário mestre - secrets manager
  username              = var.db_username
  password              = var.db_password


  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = aws_db_subnet_group.main.name

  skip_final_snapshot   = true
  storage_encrypted     = true
  multi_az              = true

  tags = merge(var.tags,{
        Name           = "${var.environment}-postgre"
    })
}