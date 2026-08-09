import { Component } from '@angular/core';
import { FormsModule, NgForm } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-login-template',
  imports: [FormsModule, CommonModule],
  templateUrl: './login-template.html',
  styleUrl: './login-template.css'
})
export class LoginTemplate {

  email = '';
  password = '';

  onSubmit(form: NgForm) {
    console.log(form.value);
  }

}