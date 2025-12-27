import { Component, OnInit } from '@angular/core';
import { ShopService } from './services/shop.service';
import { RouterOutlet, RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { CategoryMenu } from './components/category-menu/category-menu';
import { ProductList } from './components/product-list/product-list';


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, CategoryMenu, ProductList, RouterLink, RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App implements OnInit {
  title = 'starman-gui';
  currentCategory: string = '';
  userId: string = '';
  constructor(private shopService: ShopService) { }

  ngOnInit(): void {
    //grab the id to show in the top bar
    this.userId = this.shopService.getUserId();
  }

  onCategoryChange(category: string) {
    this.currentCategory = category;
  }

}
