import { Component } from '@angular/core';
import {
  ReactiveFormsModule,
  FormBuilder,
  FormGroup,
  FormArray,
  Validators
} from '@angular/forms';
import { CommonModule } from '@angular/common';

import {
  noWhitespaceValidator,
  passwordMatchValidator
} from '../validators';

@Component({
  selector: 'app-registration-reactive',
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './registration-reactive.html',
  styleUrl: './registration-reactive.css'
})
export class RegistrationReactive {

 
 registrationForm!: FormGroup;

 get skills(): FormArray {
  return this.registrationForm.get('skills') as FormArray;
}

addSkill() {
  this.skills.push(this.fb.control(''));
}

removeSkill(index: number) {

  if (this.skills.length > 1) {
    this.skills.removeAt(index);
  }

}

constructor(private fb: FormBuilder) {
this.registrationForm = this.fb.group({

  name: [
    '',
    [
      Validators.required,
      noWhitespaceValidator
    ]
  ],

  email: [
    '',
    [
      Validators.required,
      Validators.email
    ]
  ],

  password: [
    '',
    [
      Validators.required,
      Validators.minLength(6)
    ]
  ],

  confirmPassword: [
    '',
    Validators.required
  ],

  skills: this.fb.array([
    this.fb.control('')
  ])

},
{
  validators: passwordMatchValidator
});
}

onSubmit() {

  console.log("Complete Form");

  console.log(this.registrationForm.value);

  console.log("Skills");

  console.log(this.skills.value);

}

}