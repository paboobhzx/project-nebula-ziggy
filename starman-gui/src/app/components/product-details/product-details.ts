import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { ShopService } from '../../services/shop.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-product-details',
  imports: [CommonModule, FormsModule],
  templateUrl: './product-details.html',
  styleUrl: './product-details.css',
})

export class ProductDetails implements OnInit {
  product: any = null;
  loading = true;

  selectedSize: string = 'M'
  selectedColor: string = 'Black'
  selectedShipping: string = 'standard'
  //Usually the options are loaded from a DB, for this demo im hardcoding
  sizes = ['XS', 'S', 'M', 'L', 'XL'];
  colors = [
    { name: 'Black', hex: '#000000' },
    { name: 'Nebula Blue', hex: '#00d4ff' },
    { name: 'Mars Red', hex: '#ff4d4d' },
    { name: 'White', hex: '#ffffff' }
  ];

  shippingOptions = [
    { id: 'standard', name: 'Standard (5-7 days)', price: 0 },
    { id: 'express', name: 'Express (2-3 days)', price: 9.99 },
    { id: 'warp', name: 'Warp Speed (Overnight)', price: 19.99 }
  ];

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private shopService: ShopService
  ) { }

  ngOnInit(): void {
    //get the id from the url
    const productId = this.route.snapshot.paramMap.get('id');
    // 2. Fetch inventory and find this specific product
    // (In a real app, we would have a getProductById endpoint, but we can filter client-side for now)
    this.shopService.getInventory().subscribe(items => {
      this.product = items.find((i: any) => i.id == productId);
      this.loading = false;
    });

  }

  getTotalPrice(): number {
    if (!this.product) return 0;
    const shippingCost = this.shippingOptions.find(s => s.id == this.selectedShipping)?.price || 0;
    return this.product.price + shippingCost;
  }

  addToCart(redirect: boolean = false): void {
    if (!this.product) return;
    const userId = this.shopService.getUserId();

    const cartItem = {
      userName: userId,
      productId: this.product.id,
      productName: this.product.name,
      quantity: 1,
      price: this.getTotalPrice(),
      details: {
        size: this.selectedSize,
        color: this.selectedColor,
        shipping: this.selectedShipping
      }
    };
    this.shopService.addToCart(cartItem).subscribe(() => {
      alert(`${this.product.name} added to cart!`);
      if (redirect) {
        this.router.navigate(['/cart'])
      }
    });
  }

}
