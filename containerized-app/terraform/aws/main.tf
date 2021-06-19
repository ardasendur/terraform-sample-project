# Creating ECR
resource "aws_ecr_repository" "containerized_app" {
  name = var.ecr_name
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-central-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "eu-central-1b"
}

resource "aws_ecs_cluster" "containerized_app_cluster" {
  name = var.containerized_app_cluster_name
  # Naming the cluster
}

resource "aws_ecs_task_definition" "containerized_app_task" {
  family = var.containerized_app_task_name
  # Naming our first task
  container_definitions = <<DEFINITION
  [
    {
      "name": "my-first-task",
      "image": "${aws_ecr_repository.containerized_app.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = [
    "FARGATE"]
  # Stating that we are using ECS Fargate
  network_mode = "awsvpc"
  # Using awsvpc as our network mode as this is required for Fargate
  memory = 512
  # Specifying the memory our container requires
  cpu = 256
  # Specifying the CPU our container requires
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_alb" "application_load_balancer" {
  name = var.application_load_balancer_name
  # Naming our load balancer
  load_balancer_type = var.load_balancer_type
  subnets = [
    # Referencing the default subnets
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
  ]
  # Referencing the security group
  security_groups = [
    aws_security_group.load_balancer_security_group.id]
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    # Allowing traffic in from all sources
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "target-group"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_default_vpc.default_vpc.id
  # Referencing the default VPC
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  # Referencing our load balancer
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


resource "aws_ecs_service" "containerized_app_service" {
  name = var.containerized_app_service_name
  # Naming our first service
  cluster = aws_ecs_cluster.containerized_app_cluster.id
  # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.containerized_app_task.arn
  # Referencing the task our service will spin up
  launch_type = "FARGATE"
  desired_count = 1
  # Setting the number of containers to 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    # Referencing our target group
    container_name = aws_ecs_task_definition.containerized_app_task.family
    container_port = 5000
    # Specifying the container port
  }

  network_configuration {
    subnets = [
      aws_default_subnet.default_subnet_a.id,
      aws_default_subnet.default_subnet_b.id]
    assign_public_ip = true
    # Providing our containers with public IPs
    security_groups = [
      aws_security_group.service_security_group.id]
    # Setting the security group
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [
      aws_security_group.load_balancer_security_group.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}