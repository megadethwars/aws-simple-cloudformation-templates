provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr        = var.vpc_cidr
  project_name    = var.project_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "rds" {
  source = "./modules/rds"
  
  project_name    = var.project_name
  vpc_id         = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
}

module "ec2" {
  source = "./modules/ec2"
  
  project_name    = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  db_host        = module.rds.db_endpoint
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  key_name       = var.key_name
}