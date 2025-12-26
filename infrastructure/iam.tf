#execution role
resource "aws_iam_role" "ecs_execution_role" { 
    name = "starman-ecs-execution-role"
    assume_role_policy = jsonencode({ 
        Version = "2012-10-17"
        Statement = [{ 
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "ecs-tasks.amazonaws.com"}
        }]
    })
}
resource "aws_iam_role_policy_attachment" "ecs_execution_policy"{
    role = aws_iam_role.ecs_execution_role.name 
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#TASK ROLE
resource "aws_iam_role" "ecs_task_role" { 
    name = "starman-ecs-task-role"
    assume_role_policy = jsonencode({ 
        Version = "2012-10-17"
        Statement = [{ 
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "ecs-tasks.amazonaws.com"}
        }]
    })
}
#unified app policy (sns, sqs and dynamodb)
resource "aws_iam_policy" "ecs_app_policy" {
    name = "starman-ecs-app-policy"
    description = "Allow tasks to talk with sns, sqs and dynamodb"
    policy = jsonencode({ 
        Version = "2012-10-17"
        Statement = [ 
            #SNS
            { 
            Effect = "Allow"
            Action = ["sns:Publish"]
            Resource = [aws_sns_topic.order_events.arn]
            },
            #SQS
            {
                Effect = "Allow"
                Action = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
                Resource = [aws_sqs_queue.inventory_queue.arn]
            },
            #dynamodb
            { 
                Effect = "Allow"
                Action = [
                    "dynamodb:DescribeTable",
                    "dynamodb:PutItem",
                    "dynamodb:GetItem",
                    "dynamodb:DeleteItem",
                    "dynamodb:Scan",
                    "dynamodb:Query",
                    "dynamodb:UpdateItem"
                ]
                Resource = [aws_dynamodb_table.cart_table.arn]
            }

        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_management" { 
    role = aws_iam_role.ecs_task_role.name 
    policy_arn = aws_iam_policy.ecs_app_policy.arn 
}