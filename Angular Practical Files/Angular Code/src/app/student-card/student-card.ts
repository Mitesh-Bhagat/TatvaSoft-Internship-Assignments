import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Highlight } from '../highlight';
import { TruncateTextPipe } from '../truncate-text-pipe';

@Component({
  selector: 'app-student-card',
  imports: [
    CommonModule,
    Highlight,
    TruncateTextPipe
  ],
  templateUrl: './student-card.html',
  styleUrl: './student-card.css'
})
export class StudentCard {

  students = [
    { name: 'Dhruval', marks: 85 },
    { name: 'Rahul', marks: 35 },
    { name: 'Priya', marks: 92 },
    { name: 'Amit', marks: 40 },
    { name: 'Neha', marks: 55 }
  ];

  status = "approved";
   isActive = false;


   today = new Date();

   price = 25000;

   studentName = "Dhruval Gamit";

   description = "Angular is a powerful front-end framework developed by Google for building modern web applications.";
}