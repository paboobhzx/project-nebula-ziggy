import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { ShopService } from '../../services/shop.service';
import { CommonModule } from '@angular/common';
import { RouterLink, ActivatedRoute } from '@angular/router';





@Component({
  selector: 'app-product-list',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './product-list.html',
  styleUrl: './product-list.css',
})
export class ProductList {

  allProducts: any[] = [];
  filteredProducts: any[] = []
  cartMessage: string = '';
  currentCategory: string | null = null;

  constructor(private shopService: ShopService, private route: ActivatedRoute) { }

  ngOnInit(): void {
    //fetches products from AWS when the component loads
    this.shopService.getInventory().subscribe({
      next: (data) => {
        this.allProducts = data;
        this.route.queryParams.subscribe(params => {
          this.currentCategory = params['category'] || null;
          this.filterProducts();
        })

      },
      error: (err) => console.error('Error fetching products: ', err)
    });
  }

  filterProducts(): void {
    const selected = this.currentCategory;

    // EMERGENCY LOG: This will show us EXACTLY what the DB is sending
    if (this.allProducts.length > 0) {
      console.log("--- RAW DB DATA SAMPLE ---");
      console.log("First Item Category in DB:", `"${this.allProducts[0].category}"`);
      console.log("Selected Category in URL:", `"${selected}"`);
    }

    if (!selected || selected.toLowerCase().trim() === 'all products') {
      this.filteredProducts = [...this.allProducts];
      return;
    }

    this.filteredProducts = this.allProducts.filter(p => {
      if (!p || !p.category) return false;
      return p.category.toLowerCase().trim() === selected.toLowerCase().trim();
    });

    console.log(`Filtering for: ${selected}. Found: ${this.filteredProducts.length} items.`);
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
      productId: product.productId,
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
