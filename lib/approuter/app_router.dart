import 'package:edusponsor/Common/default.dart';
import 'package:edusponsor/admin/components/dashboard.dart';
import 'package:edusponsor/admin/components/institution.dart';
import 'package:edusponsor/admin/components/settings.dart';
import 'package:edusponsor/admin/components/sponsors.dart';
import 'package:edusponsor/institution/institution.dart';
import 'package:edusponsor/login/institutionregister.dart';
import 'package:edusponsor/login/login.dart';
import 'package:edusponsor/login/sponsorregistration.dart';
import 'package:edusponsor/sponsor/sponsor.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
//################  Authentication  ################//

      case '/':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case '/register/institution':
        return MaterialPageRoute(
          builder: (_) => const InstitutionRegistration(),
        );

      case '/register/sponsor':
        return MaterialPageRoute(
          builder: (_) => const SponsorRegistration(),
        );

//################  Admin  ################//

      case '/admin/dashboard':
        return MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
        );

      case '/admin/institutions':
        return MaterialPageRoute(
          builder: (_) => const AdminInstitutions(),
        );

      case '/admin/sponsors':
        return MaterialPageRoute(
          builder: (_) => const AdminSponsors(),
        );

      case '/admin/settings':
        return MaterialPageRoute(
          builder: (_) => const AdminSettings(),
        );

//################  Institution  ################//

      case '/institution/dashboard':
        return MaterialPageRoute(
          builder: (_) => const Institution(),
        );

//################  Sponsor  ################//

      case '/sponsor/dashboard':
        return MaterialPageRoute(
          builder: (_) => const Sponsor(),
        );

//################  DEFAULT  ################//

      default:
        return MaterialPageRoute(
          builder: (_) => const Default(),
        );
    }
  }
}
