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
#attach standard policy (allow pull images and write logs)
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
    role = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#task role
resource "aws_iam_role" "ecs_task_role" { 
    name = "starman-ecs-task-role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "ecs-tasks.amazonaws.com" }
        }]
    })
}
#permissions to publish to SNS and read SQS
resource "aws_iam_policy" "ecs_app_policy" {
    name = "starman-ecs-app-policy"
    description = "Allow Tasks to talk to SNS and SQS"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{ 
            Effect = "Allow"
            Action = ["sns:Publish"]
            Resource = [aws_sns_topic.order_events.arn]
        }, {
            Effect = "Allow"
            Action = ["sqs:ReceiveMessage","sqs:DeleteMessage","sqs:GetQueueAttributes"]
            Resource = [aws_sqs_queue.inventory_queue.arn]
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" { 
    role = aws_iam_role.ecs_task_role.name 
    policy_arn = aws_iam_policy.ecs_app_policy.arn 
}