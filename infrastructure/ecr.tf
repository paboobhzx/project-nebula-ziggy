#ECR for .NET Order Service
resource "aws_ecr_repository" "order_service" {
    name = "starman-order-service"
    image_tag_mutability = "MUTABLE"
    force_delete = true 
}

#ECR for Java Inventory Service
resource "aws_ecr_repository" "inventory_service" {
    name = "starman-inventory-service"
    image_tag_mutability = "MUTABLE"
    force_delete = true
}
#ECR for the .NET Cart Service
resource "aws_ecr_repository" "cart_service" {
    name = "starman-cart-service"
    image_tag_mutability = "MUTABLE"
    force_delete = true
}
output "ecr_order_url" { 
    value = aws_ecr_repository.order_service.repository_url       
    
}
output "ecr_cart_url" { 
    value = aws_ecr_repository.cart_service.repository_url
}

output "ecr_inventory_url" {
    value = aws_ecr_repository.inventory_service.repository_url
}