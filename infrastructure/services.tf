#security group for ecs tasks
#allow alb to talk to the container
resource "aws_security_group" "ecs_sg" {
    name = "starman-ecs-sg"
    description = "Allow traffic from ALB"
    vpc_id = aws_vpc.main.id 
    #inbound traffic from ALB
    ingress { 
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    #outbound - internet access (pull images, talk to sns/sqs)
    egress { 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#.NET Order Service
resource "aws_ecs_task_definition" "order_task" { 
    family = "starman-order-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_execution_role.arn 
    task_role_arn = aws_iam_role.ecs_task_role.arn 
    container_definitions = jsonencode([{ 
        name = "order-container"
        image = "${aws_ecr_repository.order_service.repository_url}:latest"
        cpu = 256
        memory = 512
        essential = true 
        portMappings = [{
            containerPort = 8080
            hostPort = 8080
        }]
        environment= [
            { name = "ASPNETCORE_ENVIRONMENT", value = "Development"}, #to show swagger
            { name = "AWS_REGION", value = "us-east-1"}
        ]
        logConfiguration = { 
            logDriver = "awslogs"
            options = { 
                "awslogs-group" = aws_cloudwatch_log_group.ecs_logs.name 
                "awslogs-region" = "us-east-1"
                "awslogs-stream-prefix" = "order-service"
            }
        }
    }])
}

resource "aws_ecs_service" "order_service" { 
    name = "starman-order-service"
    cluster = aws_ecs_cluster.main.id 
    task_definition = aws_ecs_task_definition.order_task.arn 
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration { 
        subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
        security_groups = [aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }

    load_balancer { 
        target_group_arn = aws_lb_target_group.orders_tg.arn 
        container_name = "order-container"
        container_port = 8080
    }
}

#JAVA INVENTORY SERVICe
resource "aws_ecs_task_definition" "inventory_task" { 
    family = "starman-inventory-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_execution_role.arn 
    task_role_arn = aws_iam_role.ecs_task_role.arn 
    container_definitions = jsonencode([
        { 
            name = "inventory-container"
            image = "${aws_ecr_repository.inventory_service.repository_url}:latest"
            cpu = 256
            memory = 512
            essential = true
            portMappings = [{
                containerPort = 9090
                hostPort = 9090
            }]
            environment = [ 
                { name = "INVENTORY_QUEUE_URL", value = aws_sqs_queue.inventory_queue.url},
                { name = "SPRING_DATASOURCE_URL", value = "jdbc:mysql://${aws_db_instance.default.address}:3306/starman_db?useSSL=false&allowPublicKeyRetrieval=true"},
                { name = "SPRING_DATASOURCE_USERNAME", value = "admin"},
                { name = "SPRING_DATASOURCE_PASSWORD", value = "StarmanPassword123!"}
            ]
            logConfiguration = { 
                logDriver = "awslogs"
                options = { 
                    "awslogs-group" = aws_cloudwatch_log_group.ecs_logs.name 
                    "awslogs-region" = "us-east-1"
                    "awslogs-stream-prefix" = "inventory-service"
                }
            }
        }
    ])
}

resource "aws_ecs_service" "inventory_service" {
    name = "starman-inventory-service"
    cluster = aws_ecs_cluster.main.id 
    task_definition = aws_ecs_task_definition.inventory_task.arn 
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration { 
        subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
        security_groups = [aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }
    load_balancer { 
        target_group_arn = aws_lb_target_group.inventory_tg.arn 
        container_name = "inventory-container"
        container_port = 9090

    }
}
#NET Cart Service (DynamoDB)
resource "aws_ecs_task_definition" "cart_task" { 
    family = "starman-cart-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecs_execution_role.arn 
    task_role_arn = aws_iam_role.ecs_task_role.arn 
    container_definitions = jsonencode([
        { 
            name = "cart-container"
            image = "${aws_ecr_repository.cart_service.repository_url}:latest"
            cpu = 256
            memory = 512
            essential = true 
            portMappings = [{
                containerPort = 8080
                hostPort = 8080
            }]
            environment = [
                { name = "ASPNETCORE_ENVIRONMENT", value = "Development"},
                { name = "AWS_REGION", value = "us-east-1"}
            ]
            logConfiguration = { 
                logDriver = "awslogs"
                options = { 
                    "awslogs-group" = aws_cloudwatch_log_group.ecs_logs.name
                    "awslogs-region" = "us-east-1"
                    "awslogs-stream-prefix" = "cart-service"
                }
            }
        }
    ])
}
resource "aws_ecs_service" "cart_service" {
    name = "starman-cart-service"
    cluster = aws_ecs_cluster.main.id 
    task_definition = aws_ecs_task_definition.cart_task.arn 
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration { 
        subnets = [aws_subnet.public_1.id,aws_subnet.public_2.id ]
        security_groups =[aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }
    load_balancer { 
        target_group_arn = aws_lb_target_group.cart_tg.arn 
        container_name = "cart-container"
        container_port = 8080
    }
}