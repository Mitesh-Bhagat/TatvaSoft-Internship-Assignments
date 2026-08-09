import { Component } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-products',
  imports: [],
  templateUrl: './products.html',
  styleUrl: './products.css'
})
export class Products {

  page = '';
  sort = '';

  constructor(private route: ActivatedRoute) {

    this.route.queryParamMap.subscribe(params => {

      this.page = params.get('page') ?? '1';
      this.sort = params.get('sort') ?? 'default';

    });

  }

}