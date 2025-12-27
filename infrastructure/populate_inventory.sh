#!/bin/bash

# Get the ALB URL from Terraform output
ALB_URL=$(terraform output -raw alb_dns_name)

if [ -z "$ALB_URL" ]; then
    echo "Error: Could not get ALB URL from terraform output."
    exit 1
fi

echo "Populating Inventory via ALB: http://$ALB_URL"
echo "---------------------------------------------"

# FUNCTION: Generates a random ID and sends the item
send_product() {
    NAME="$1"
    PRICE="$2"
    QTY="$3"
    CAT="$4"
    
    # Generate a random 6-digit Product ID (e.g., PROD-849201)
    PROD_ID="PROD-$((100000 + RANDOM % 999999))"

    # Build the JSON string with the new productId
    # We use printf to safely format the string
    JSON_PAYLOAD=$(printf '{"productId": "%s", "name": "%s", "price": %s, "quantity": %s, "category": "%s"}' "$PROD_ID" "$NAME" "$PRICE" "$QTY" "$CAT")

    # Send to AWS
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "http://$ALB_URL/api/inventory" \
         -H "Content-Type: application/json" \
         -d "$JSON_PAYLOAD")
    
    echo " - Sent: $NAME ($PROD_ID) -> Status: $HTTP_CODE"
}

# --- Mens ---
send_product "Mens Tech T-Shirt" 25.00 50 "Mens"
send_product "Mens Running Shorts" 35.50 40 "Mens"
send_product "Mens Lightweight Hoodie" 55.00 30 "Mens"
send_product "Mens Training Pants" 45.00 35 "Mens"

# --- Womens ---
send_product "Womens Yoga Leggings" 40.00 60 "Womens"
send_product "Womens Sports Bra High-Impact" 32.00 50 "Womens"
send_product "Womens Running Tank" 22.50 45 "Womens"
send_product "Womens Cropped Hoodie" 48.00 25 "Womens"

# --- Kids ---
send_product "Kids Active PE Kit" 20.00 70 "Kids"
send_product "Kids Junior Trainers" 30.00 40 "Kids"
send_product "Kids Spider-Man Rashguard" 28.00 30 "Kids"

# --- Gym Clothing ---
send_product "Unisex Compression Socks" 15.00 100 "Gym Clothing"
send_product "Performance Sweatband Set" 10.00 120 "Gym Clothing"
send_product "Thermal Base Layer Top" 38.00 40 "Gym Clothing"

# --- Gym Accessories ---
send_product "Starman Protein Shaker Bottle" 12.00 150 "Gym Accessories"
send_product "Resistance Bands Set (5-Pack)" 25.00 80 "Gym Accessories"
send_product "Foam Roller (High Density)" 30.00 40 "Gym Accessories"
send_product "Gym Duffel Bag" 45.00 30 "Gym Accessories"
send_product "Lifting Straps Padded" 18.00 60 "Gym Accessories"

echo "---------------------------------------------"
echo "Population complete. Check your Angular app!"