import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';



@Component({
  selector: 'app-category-menu',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './category-menu.html',
  styleUrl: './category-menu.css',
})
export class CategoryMenu {
  @Output() categorySelected = new EventEmitter<string>();
  categories = [
    'All Products',
    'Mens',
    'Womens',
    'Kids',
    'Gym Clothing',
    'Gym Accessories'
  ];
  selectedCategory = 'All Products';
  constructor(private router: Router) { }
  onSelect(category: string): void {
    this.selectedCategory = category;
    const catParam = category === 'All Products' ? null : category;
    this.router.navigate(['/'], { queryParams: { category: catParam } });
  }

}
