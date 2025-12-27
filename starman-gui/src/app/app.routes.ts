import { Routes } from '@angular/router';
import { ProductList } from './components/product-list/product-list';
import { Cart } from './components/cart/cart';
import { ProductDetails } from './components/product-details/product-details';



export const routes: Routes = [
    { path: '', component: ProductList },
    { path: 'cart', component: Cart },
    { path: 'product/:id', component: ProductDetails },
    { path: '**', redirectTo: '' }
]
