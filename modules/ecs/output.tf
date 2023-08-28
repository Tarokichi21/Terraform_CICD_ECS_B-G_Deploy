output "endpoint" {
  value = "endpoint: http://${aws_lb.alb.dns_name}"
}


output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "ecs_service_id" {
  value = aws_ecs_service.ecs_service.id
}

output "ecs_task_definition_family" {
  value = aws_ecs_task_definition.ecs_task_definition.family
}


output "alb_tg_blue_name" {
  value = aws_lb_target_group.alb_tg_blue.name
}

output "alb_tg_green_name" {
  value = aws_lb_target_group.alb_tg_green.name
}

output "alb_listner_prod_arn" {
  value = aws_lb_listener.alb_listner_prod.arn
}

output "alb_listner_test_arn" {
  value = aws_lb_listener.alb_listner_test.arn
}

##codebuild_環境変数用
output "ecs_task_execution_role_arn" {
  value = aws_ecs_task_definition.ecs_task_definition.execution_role_arn
}

output "ecs_task_role_arn" {
  value = aws_ecs_task_definition.ecs_task_definition.task_role_arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.cloudwatch_log_group.name
}