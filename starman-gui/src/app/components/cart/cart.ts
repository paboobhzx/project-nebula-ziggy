import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ShopService } from '../../services/shop.service';
import { RouterLink, Router } from '@angular/router';

@Component({
  selector: 'app-cart',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './cart.html',
  styleUrl: './cart.css',
})
export class Cart implements OnInit {
  cartItems: any[] = [];
  totalPrice: number = 0;
  loading: boolean = false;
  constructor(private shopService: ShopService, private router: Router) { }

  ngOnInit(): void {
    this.loadCart();
  }

  loadCart(): void {
    const userId = this.shopService.getUserId();
    this.shopService.getCart(userId).subscribe({
      next: (data) => {
        this.cartItems = data;
        this.calculateTotal();
        this.loading = false;
      },
      error: (err) => {
        console.error('Failed to load cart: ', err);
        this.loading = false;
      }
    });
  }
  calculateTotal(): void {
    //Sum up price * quantity for all items
    this.totalPrice = this.cartItems.reduce((acc, item) => acc + (item.price * item.quantity), 0);
  }
  checkout(): void {
    alert("Initiating checkout sequence ... ")
  }

}
