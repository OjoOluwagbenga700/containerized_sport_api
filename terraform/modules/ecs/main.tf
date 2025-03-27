# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# IAM role for the ECS task execution

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Version": "2012-10-17", 
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

# Attach the AmazonECSTaskExecutionRolePolicy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Create ECS task definition

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "sports-api-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 256
  memory                  = 512
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn          = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "sports-api-container"
      image = "${var.ecr_repo_url}:latest"
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }

      ]
      environment = [
        {
          name  = "SPORTS_API_KEY"
          value = var.sports_api_key
        }
      ]
    }
  ])
}
# ECS service 
resource "aws_ecs_service" "ecs_service" {

  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  

  network_configuration {
    subnets          = [var.public_subnet1_id, var.public_subnet2_id]
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "ECS"
  }


  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "sports-api-container"
    container_port   = var.container_port
  }
  
}