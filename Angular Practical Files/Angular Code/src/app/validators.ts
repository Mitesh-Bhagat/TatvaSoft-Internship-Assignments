import {
  AbstractControl,
  ValidationErrors
} from '@angular/forms';

export function noWhitespaceValidator(
  control: AbstractControl
): ValidationErrors | null {

  const value = control.value;

  if (!value) {
    return null;
  }

  if (value.trim().length === 0) {
    return { whitespace: true };
  }

  return null;
}

export function passwordMatchValidator(
  control: AbstractControl
): ValidationErrors | null {

  const password = control.get('password')?.value;
  const confirmPassword = control.get('confirmPassword')?.value;

  if (password === confirmPassword) {
    return null;
  }

  return { passwordMismatch: true };
}