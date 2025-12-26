import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { ShopService } from '../../services/shop.service';
import { CommonModule } from '@angular/common';




@Component({
  selector: 'app-product-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './product-list.html',
  styleUrl: './product-list.css',
})
export class ProductList {
  @Input() selectedCategory: string = '';
  allProducts: any[] = [];
  filteredProducts: any[] = []
  cartMessage: string = '';

  constructor(private shopService: ShopService) { }

  ngOnInit(): void {
    //fetches products from AWS when the component loads
    this.shopService.getInventory().subscribe({
      next: (data) => {
        this.allProducts = data;
        this.filterProducts();
      },
      error: (err) => console.error('Error fetching products: ', err)
    });
  }
  ngOnChanges(changes: SimpleChanges): void {
    if (changes['selectedCategory']) {
      this.filterProducts();
    }
  }

  filterProducts(): void {
    if (!this.selectedCategory) {
      this.filteredProducts = this.allProducts;
    } else {
      this.filteredProducts = this.allProducts.filter(p => p.category == this.selectedCategory);
    }
  }
  getColor(category: string): string {
    switch (category) {
      case 'Mens': return '#0d6efd';       // Blue
      case 'Womens': return '#d63384';     // Pink
      case 'Kids': return '#ffc107';       // Yellow
      case 'Gym Clothing': return '#198754'; // Green
      case 'Gym Accessories': return '#6f42c1'; // Purple
      default: return '#6c757d';           // Gray
    }

  }
  buy(product: any): void {
    const currentUserId = this.shopService.getUserId();
    const item = {
      userName: currentUserId,
      productId: product.id,
      quantity: 1,
      price: product.price
    };

    this.shopService.addToCart(item).subscribe({
      next: () => {
        this.cartMessage = `Added ${product.name} to cart`;
        setTimeout(() => this.cartMessage = '', 3000);
      },
      error: (err) => console.error(err)
    });

  }

}
