import { Component } from '@angular/core';
import { Auth } from '../auth';

@Component({
  selector: 'app-login',
  imports: [],
  templateUrl: './login.html',
  styleUrl: './login.css'
})
export class Login {

  constructor(private auth: Auth) {}

  login() {
    this.auth.login();
  }

  logout() {
    this.auth.logout();
  }

}