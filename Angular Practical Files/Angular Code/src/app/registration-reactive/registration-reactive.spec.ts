import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistrationReactive } from './registration-reactive';

describe('RegistrationReactive', () => {
  let component: RegistrationReactive;
  let fixture: ComponentFixture<RegistrationReactive>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RegistrationReactive],
    }).compileComponents();

    fixture = TestBed.createComponent(RegistrationReactive);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
