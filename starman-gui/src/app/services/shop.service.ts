import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';


@Injectable({
  providedIn: 'root',
})
export class ShopService {
  private baseUrl = '/api'

  constructor(private http: HttpClient) { }
  getUserId(): string {
    let userId = localStorage.getItem('starman_user_id')
    if (!userId) {
      userId = 'user-' + Math.floor(Math.random() * 1000000);
      localStorage.setItem('starman_user_id', userId);

    }
    return userId;
  }

  getInventory(): Observable<any> {
    return this.http.get(`${this.baseUrl}/inventory`);
  }

  addToCart(item: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/cart`, item);
  }

}
