#ECS Cluster
resource "aws_ecs_cluster" "main" {
    name = "starman-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
    name = "/ecs/starman-apps"
    retention_in_days = 7
}