#!/bin/bash

# Get the ALB URL from Terraform output
ALB_URL=$(terraform output -raw alb_dns_name)

if [ -z "$ALB_URL" ]; then
    echo "Error: Could not get ALB URL from terraform output."
    exit 1
fi

echo "Populating Inventory via ALB: http://$ALB_URL"
echo "---------------------------------------------"

send_product() {
    curl -s -o /dev/null -w "%{http_code}" -X POST "http://$ALB_URL/api/inventory" \
         -H "Content-Type: application/json" \
         -d "$1"
    echo " - Sent: $2"
}

# --- Mens ---
send_product '{"name": "Men’s Tech T-Shirt", "price": 25.00, "quantity": 50, "category": "Mens"}' "Tech T-Shirt"
send_product '{"name": "Men’s Running Shorts", "price": 35.50, "quantity": 40, "category": "Mens"}' "Running Shorts"
send_product '{"name": "Men’s Lightweight Hoodie", "price": 55.00, "quantity": 30, "category": "Mens"}' "Lightweight Hoodie"
send_product '{"name": "Men’s Training Pants", "price": 45.00, "quantity": 35, "category": "Mens"}' "Training Pants"

# --- Womens ---
send_product '{"name": "Women’s Yoga Leggings", "price": 40.00, "quantity": 60, "category": "Womens"}' "Yoga Leggings"
send_product '{"name": "Women’s Sports Bra High-Impact", "price": 32.00, "quantity": 50, "category": "Womens"}' "Sports Bra"
send_product '{"name": "Women’s Running Tank", "price": 22.50, "quantity": 45, "category": "Womens"}' "Running Tank"
send_product '{"name": "Women’s Cropped Hoodie", "price": 48.00, "quantity": 25, "category": "Womens"}' "Cropped Hoodie"

# --- Kids ---
send_product '{"name": "Kid’s Active PE Kit", "price": 20.00, "quantity": 70, "category": "Kids"}' "PE Kit"
send_product '{"name": "Kid’s Junior Trainers", "price": 30.00, "quantity": 40, "category": "Kids"}' "Junior Trainers"
send_product '{"name": "Kid’s Spider-Man Rashguard", "price": 28.00, "quantity": 30, "category": "Kids"}' "Rashguard"

# --- Gym Clothing (Unisex/General) ---
send_product '{"name": "Unisex Compression Socks", "price": 15.00, "quantity": 100, "category": "Gym Clothing"}' "Compression Socks"
send_product '{"name": "Performance Sweatband Set", "price": 10.00, "quantity": 120, "category": "Gym Clothing"}' "Sweatband Set"
send_product '{"name": "Thermal Base Layer Top", "price": 38.00, "quantity": 40, "category": "Gym Clothing"}' "Base Layer"

# --- Gym Accessories ---
send_product '{"name": "Starman Protein Shaker Bottle", "price": 12.00, "quantity": 150, "category": "Gym Accessories"}' "Shaker Bottle"
send_product '{"name": "Resistance Bands Set (5-Pack)", "price": 25.00, "quantity": 80, "category": "Gym Accessories"}' "Resistance Bands"
send_product '{"name": "Foam Roller (High Density)", "price": 30.00, "quantity": 40, "category": "Gym Accessories"}' "Foam Roller"
send_product '{"name": "Gym Duffel Bag", "price": 45.00, "quantity": 30, "category": "Gym Accessories"}' "Duffel Bag"
send_product '{"name": "Lifting Straps Padded", "price": 18.00, "quantity": 60, "category": "Gym Accessories"}' "Lifting Straps"

echo "---------------------------------------------"
echo "Population complete. Check your Angular app!"
