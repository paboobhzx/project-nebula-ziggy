import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';


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
    'Gym Acessories'
  ];
  selectedCategory = 'All Products';
  onSelect(category: string): void {
    this.selectedCategory = category;
    this.categorySelected.emit(category === 'All Products' ? '' : category);
  }

}
