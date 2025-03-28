#Create Custom VPC
module "networking" {
  source               = "./modules/networking"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet1_cidr  = var.public_subnet1_cidr
  public_subnet2_cidr  = var.public_subnet2_cidr
  private_subnet1_cidr = var.private_subnet1_cidr
  private_subnet2_cidr = var.private_subnet2_cidr

}

# Create Application Load Balancer
module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  public_subnet1_id = module.networking.public_subnet1_id
  public_subnet2_id = module.networking.public_subnet2_id
  alb_sg_id         = module.networking.alb_sg_id
  vpc_id            = module.networking.vpc_id
  depends_on        = [module.networking]
}

module "api-gateway" {
  source           = "./modules/api-gateway"
  project_name     = var.project_name
  alb_dns_endpoint = module.alb.alb_dns_endpoint
  depends_on       = [module.alb]

}


module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name
  region          = var.region

}

module "ecs" {
  source            = "./modules/ecs"
  cluster_name      = var.cluster_name
  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  ecr_repo_url      = module.ecr.ecr_repo_url
  container_port    = var.container_port
  host_port         = var.host_port
  service_name      = var.service_name
  public_subnet1_id = module.networking.public_subnet1_id
  public_subnet2_id = module.networking.public_subnet2_id
  alb_tg_arn        = module.alb.alb_tg_arn
  ecs_sg_id         = module.networking.ecs_sg_id
  sports_api_key    = var.sports_api_key

  depends_on = [module.alb, module.ecr]



}