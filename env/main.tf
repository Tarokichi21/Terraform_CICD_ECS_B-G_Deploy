locals {
  project_name = "ecscicd"
  environment  = "dev"
  region       = "ap-northeast-1"
  account_id   = "410362506341"
}

provider "aws" {
  region  = local.region
  profile = "terraform"
}

terraform {
  backend "s3" {
    profile = "terraform"
    bucket  = "ecscicd0001"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
  }
}

module "cicd" {
  source                     = "../modules/cicd"
  project_name               = local.project_name
  environment                = local.environment
  account_id                 = local.account_id
  ecs_cluster_name           = module.ecs.ecs_cluster_name
  ecs_cluster_arn            = module.ecs.ecs_cluster_arn
  ecs_service_name           = module.ecs.ecs_service_name
  ecs_service_id             = module.ecs.ecs_service_id
  ecs_task_definition_family = module.ecs.ecs_task_definition_family
  ecs_task_execution_role_arn = module.ecs.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.ecs.ecs_task_role_arn
  alb_tg_blue_name           = module.ecs.alb_tg_blue_name
  alb_tg_green_name          = module.ecs.alb_tg_green_name
  alb_listner_prod_arn          = module.ecs.alb_listner_prod_arn
  alb_listner_test_arn          = module.ecs.alb_listner_test_arn
  cloudwatch_log_group_name      = module.ecs.cloudwatch_log_group_name
  container_name                = "fargate"

}

module "ecr" {
  source       = "../modules/ecr"
  project_name = local.project_name
  environment  = local.environment
  account_id   = local.account_id
}

module "ecs" {
  source               = "../modules/ecs"
  project_name         = local.project_name
  environment          = local.environment
  account_id           = local.account_id
  region               = local.region
  fargate_cpu          = 256 // MB
  fargate_memory       = 512 // MB
  container_name       = "fargate"
  desired_count        = 2
  ecr_repo_url         = "${module.ecr.ecr_repository_url}:latest"
}
