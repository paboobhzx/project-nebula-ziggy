resource "aws_dynamodb_table" "cart_table" {
    name = "starman-cart-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "UserName"
    range_key = "ProductId"
    attribute { 
        name = "UserName"
        type = "S"
    }
    attribute { 
        name = "ProductId"
        type = "S"
    }
    ttl { 
        enabled = true
        attribute_name = "expiry_time"
    }
}