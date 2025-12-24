terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}
#SNS Topic
resource "aws_sns_topic" "order_events" {
    name = "starman-orders-event-topic"
}
#Output the ARN
output "sns_topic_arn" {
    value = aws_sns_topic.order_events.arn 
}
#Inventory SQS Queue
resource "aws_sqs_queue" "inventory_queue" {
    name = "starman-inventory-queue"
    message_retention_seconds = 86400
}
#SNS Subscription
resource "aws_sns_topic_subscription" "inventory_sqs_target" {
    topic_arn = aws_sns_topic.order_events.arn
    protocol = "sqs"
    endpoint = aws_sqs_queue.inventory_queue.arn 
}
#Permissions
resource "aws_sqs_queue_policy" "allow_sns_write" {
    queue_url = aws_sqs_queue.inventory_queue.id 
    policy = data.aws_iam_policy_document.sns_sqs_policy.json 
}
data "aws_iam_policy_document" "sns_sqs_policy" {
  statement {
    sid    = "AllowSNSMessages"
    effect = "Allow"
    actions = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.inventory_queue.arn]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.order_events.arn]
    }
  }
}
output "inventory_queue_url" {
    value = aws_sqs_queue.inventory_queue.url
}