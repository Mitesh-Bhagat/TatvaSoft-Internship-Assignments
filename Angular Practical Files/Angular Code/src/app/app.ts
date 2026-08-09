import { Component } from '@angular/core';
// import { StudentCard } from './student-card/student-card';
// import { LoginTemplate } from './login-template/login-template';
import { RegistrationReactive } from './registration-reactive/registration-reactive';
import { RouterModule } from '@angular/router';
@Component({
  selector: 'app-root',
  imports: [
    RouterModule
  ],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
}