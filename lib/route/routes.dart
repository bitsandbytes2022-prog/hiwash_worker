import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hiwash_worker/featuers/qr_scanner/view/reward_qr.dart';
import 'package:hiwash_worker/featuers/today_wash/view/today_wash_screen.dart';


import '../featuers/auth/view/login_otp_screen.dart';
import '../featuers/auth/view/login_screen.dart';
import '../featuers/auth/view/splash_screen.dart';
import '../featuers/auth/view/welcome_screen.dart';

import '../featuers/dashboard/view/dashbord_screen.dart';
import '../featuers/dashboard/view/widget/second_drawer/faq_screen.dart';
import '../featuers/dashboard/view/widget/second_drawer/help_desk_ticket_screen.dart';
import '../featuers/dashboard/view/widget/second_drawer/step_by_step_guide_detail_screen.dart';
import '../featuers/dashboard/view/widget/second_drawer/step_by_step_guide_screen.dart';
import '../featuers/qr_scanner/view/qr_scanner.dart';
import '../featuers/subscription/view/enter_card_detail_screen.dart';
import '../featuers/subscription/view/payment_success_screen.dart';
import '../featuers/subscription/view/subscription_screen.dart';
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
  name: RouteStrings.loginOtpScreen,
  page: () => LoginOtpScreen(),
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
  name: RouteStrings.todayWashScreen,
  page: () => TodayWashScreen(),
 ),

    GetPage(
  name: RouteStrings.dashboardScreen,
  page: () => DashboardScreen(),
 ),

    GetPage(
  name: RouteStrings.faqScreen,
  page: () => FaqScreen(),
 ),

    GetPage(
  name: RouteStrings.helpDeskTicketScreen,
  page: () => HelpDeskTicketScreen(),
 ),
    GetPage(
  name: RouteStrings.stepByStepGuideScreen,
  page: () => StepByStepGuideScreen(),
 ),

  GetPage(
  name: RouteStrings.stepByStepGuideDetailScreen,
  page: () => StepByStepGuideDetailScreen(),
 ),
 GetPage(
  name: RouteStrings.qrScreen,
  page: () => QrScreen(),
 ),

    GetPage(
  name: RouteStrings.rewardQrScreen,
  page: () => RewardQrScreen(),
 ),




  ];



}