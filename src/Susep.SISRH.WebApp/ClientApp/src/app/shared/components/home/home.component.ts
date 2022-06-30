import { Component, OnInit } from '@angular/core';
import { ApplicationStateService } from '../../services/application.state.service';
import { Router } from '@angular/router';
import { SecurityService } from '../../services/security.service';

@Component({
  selector: 'corretores-home',
  templateUrl: './home.component.html'
})
export class HomeComponent implements OnInit {

  isAuthenticated: boolean;

  constructor(
    private applicationState: ApplicationStateService,
    private router: Router,
    private securityService: SecurityService
  ) { }

  ngOnInit() {
    this.applicationState.isAuthenticated.subscribe(value => {
      this.isAuthenticated = value;
      if (this.isAuthenticated) {
        this.router.navigateByUrl('/dashboard');
      }
      else {
        // this.router.navigateByUrl('/login');
        this.securityService.authenticate('', '')
        .subscribe(ret => {
          if (ret.token_type !== 'Bearer')
            console.error(ret.token_type);
        });
      }
    });
  }

}
