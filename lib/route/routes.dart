import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hiwash_worker/featuers/auth/view/forgot_password_screen.dart';
import 'package:hiwash_worker/featuers/auth/view/reset_password_screen.dart';
import 'package:hiwash_worker/featuers/auth/view/splash_screen.dart';
import 'package:hiwash_worker/featuers/subscription/view/enter_card_detail_screen.dart';
import 'package:hiwash_worker/featuers/subscription/view/payment_success_screen.dart';
import 'package:hiwash_worker/featuers/subscription/view/subscription_screen.dart';
import 'package:hiwash_worker/featuers/wash_status/view/wash_status_screen.dart';

import '../featuers/auth/view/login_screen.dart';
import '../featuers/auth/view/otp_screen.dart';
import '../featuers/auth/view/sign_up_screen.dart';
import '../featuers/auth/view/welcome_screen.dart';
import '../featuers/dashboard/view/dashbord_screen.dart';
import 'route_strings.dart';

class Routes {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static final pages = [
  GetPage(
  name: RouteStrings.splashScreen,
  page: () => SplashScreen(),
 ),
    GetPage(
  name: RouteStrings.welcomeScreen,
  page: () => WelcomeScreen(),
 ),
    GetPage(
  name: RouteStrings.subscriptionScreen,
  page: () => SubscriptionScreen(),
 ),

    GetPage(
  name: RouteStrings.loginScreen,
  page: () => LoginScreen(),
 ),
    GetPage(
  name: RouteStrings.signUpScreen,
  page: () => SignUpScreen(),
 ),

    GetPage(
  name: RouteStrings.forgotPasswordScreen,
  page: () => ForgotPasswordScreen(),
 ),
    GetPage(
  name: RouteStrings.otpScreen,
  page: () => OtpScreen(),
 ),

    GetPage(
  name: RouteStrings.resetPasswordScreen,
  page: () => ResetPasswordScreen(),
 ),

    GetPage(
  name: RouteStrings.enterCardDetailScreen,
  page: () => EnterCardDetailScreen(),
 ),
    GetPage(
  name: RouteStrings.paymentSuccessScreen,
  page: () => PaymentSuccessScreen(),
 ),
  GetPage(
  name: RouteStrings.washStatusScreen,
  page: () => WashStatusScreen(),
 ),

    GetPage(
  name: RouteStrings.dashboardScreen,
  page: () => DashboardScreen(),
 ),




  ];



}