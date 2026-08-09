import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-home',
  imports: [RouterModule, CommonModule],
  templateUrl: './home.html',
  styleUrl: './home.css'
})
export class Home {

  users = [
    { id: 1, name: 'Dhruval' },
    { id: 2, name: 'Rahul' },
    { id: 3, name: 'Priya' },
    { id: 4, name: 'Amit' },
    { id: 5, name: 'Neha' }
  ];

}