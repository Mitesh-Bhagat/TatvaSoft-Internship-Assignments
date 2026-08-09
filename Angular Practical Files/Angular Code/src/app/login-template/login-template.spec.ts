import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LoginTemplate } from './login-template';

describe('LoginTemplate', () => {
  let component: LoginTemplate;
  let fixture: ComponentFixture<LoginTemplate>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LoginTemplate],
    }).compileComponents();

    fixture = TestBed.createComponent(LoginTemplate);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
