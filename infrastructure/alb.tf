#SG
resource "aws_security_group" "alb_sg" {
    name = "starman-alb-sg"
    description = "Allow HTTP traffic from the world"
    vpc_id = aws_vpc.main.id 

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress { 
        from_port = 0
        to_port = 0
        protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_lb" "main" {
    name = "starman-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]

   
   
}
 #target group - orders
 resource "aws_lb_target_group" "orders_tg" {
        name = "starman-orders-tg"
        port = 8080
        protocol = "HTTP"
        vpc_id = aws_vpc.main.id 
        target_type = "ip" #fargate
        health_check { 
            path = "/health"
        }
    }
#inventory service target group
resource "aws_lb_target_group" "inventory_tg" {
    name = "starman-inventory-tg"
    port = 9090
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id 
    target_type = "ip"
    health_check { 
        path = "/actuator/health"
    }
}
#routing rules (listener)
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.main.arn 
    port = 80
    protocol = "HTTP"
    #Default Action: Return 404
    default_action { 
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "404: Starman Not Found"
            status_code = "404"

        }
    }
}

#route /api/orders to Order Service
resource "aws_lb_listener_rule" "orders_rule" { 
    listener_arn = aws_lb_listener.http.arn 
    priority = 100
    action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.orders_tg.arn 
    }
    condition { 
        path_pattern {
            values = ["/api/Orders"]
        }
    }
}
#actuator route
resource "aws_lb_listener_rule" "inventory_rule" { 
    listener_arn = aws_lb_listener.http.arn 
    priority = 200
    action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.inventory_tg.arn 
    }
    condition { 
        path_pattern { 
            values = ["/actuator/*"]
        }
    }
}
output "alb_dns_name" { 
    value = aws_lb.main.dns_name 
}