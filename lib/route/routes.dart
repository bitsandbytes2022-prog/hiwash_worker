import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hiwash_worker/featuers/auth/view/splash_screen.dart';

import 'package:hiwash_worker/featuers/wash_status/view/wash_status_screen.dart';

import '../featuers/auth/view/login_screen.dart';
import '../featuers/auth/view/welcome_screen.dart';
import '../featuers/dashboard/view/dashbord_screen.dart';
import 'route_strings.dart';

class Routes {

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final pages = [
    GetPage(name: RouteStrings.splashScreen, page: () => SplashScreen()),
    GetPage(name: RouteStrings.welcomeScreen, page: () => WelcomeScreen()),
    GetPage(name: RouteStrings.loginScreen, page: () => LoginScreen()),
    GetPage(
      name: RouteStrings.washStatusScreen,
      page: () => WashStatusScreen(),
    ),

    GetPage(name: RouteStrings.dashboardScreen, page: () => DashboardScreen()),
  ];
}
