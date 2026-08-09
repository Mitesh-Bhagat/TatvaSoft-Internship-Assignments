import { Routes } from '@angular/router';

import { Home } from './home/home';
import { Contact } from './contact/contact';
import { User } from './user/user';
import { PageNotFound } from './page-not-found/page-not-found';
import { Products } from './products/products';

import { Dashboard } from './dashboard/dashboard';
import { Users } from './dashboard/users/users';
import { Orders } from './dashboard/orders/orders';
import { Settings } from './dashboard/settings/settings';

import { Profile } from './profile/profile';
import { Login } from './login/login';
import { authGuard } from './auth-guard';
export const routes: Routes = [

  {
    path: '',
    component: Home
  },

{
  path: 'about',
  loadComponent: () =>
    import('./about/about').then(m => m.About)
},

  {
    path: 'contact',
    component: Contact
  },

  {
  path: 'users/:id',
  component: User
  },

  {
  path: 'products',
  component: Products
},


{
  path: 'dashboard',
  component: Dashboard,
  children: [

    {
      path: 'users',
      component: Users
    },

    {
      path: 'orders',
      component: Orders
    },

    {
      path: 'settings',
      component: Settings
    },

    {
      path: '',
      redirectTo: 'users',
      pathMatch: 'full'
    }

  ]
  },

  {
  path: 'reports',
  loadChildren: () =>
    import('./reports.routes').then(m => m.REPORT_ROUTES)
},


{
  path: 'login',
  component: Login
},

{
  path: 'profile',
  component: Profile,
  canActivate: [authGuard]
},

  {
    path: '**',
    component: PageNotFound
  }

];