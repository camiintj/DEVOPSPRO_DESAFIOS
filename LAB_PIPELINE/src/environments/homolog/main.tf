terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


module "network" {
  source      = "../../modules/network"
  environment = "homolog"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
  eks_private_subnet  = ["10.0.101.0/24", "10.0.102.0/24"]
  rds_private_subnet  = ["10.0.201.0/24", "10.0.202.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  tags = {
    Project     = "DevOpsPro Pipeline"
    Environment = "Homolog"
  }
}

module "rds" {
  source      = "../../modules/rds"
  environment = "homolog"

  subnet_ids        = module.network.rds_subnet_ids
  security_group_ids = [module.network.rds_security_group_id]

  db_name          = "pipelineelite"
  db_username      = "pipeline_elite"
  db_password      = "pipeline_elite_password"

  tags = {
    Project     = "DevOpsPro Pipeline"
    Environment = "Homolog"

  }
}