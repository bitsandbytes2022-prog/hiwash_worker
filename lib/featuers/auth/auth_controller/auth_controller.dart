import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/language/String_constant.dart';

import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../../../route/route_strings.dart';
import '../../../widgets/components/app_snack_bar.dart';
import '../model/get_token_model.dart';
import '../model/send_otp_model.dart';
import '../model/sign_up_model.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  var isLoading = false.obs;
  var enteredOtp = ''.obs;
  var secondsRemaining = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    pageController.addListener(() {
      onPageChanged(pageController.page!.round());
    });
    checkLoginStatus();
    super.onInit();
  }

  GetTokenModel? getTokenModel;

  SignUpModel? signUpModel;

  /// login controller
  TextEditingController loginPhoneController = TextEditingController(
    text:kDebugMode? "6446544689":'',
  );


  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  /// Welcome screen
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }


  Future getFCMTokenIn() async {
    var token = await FirebaseMessaging.instance.getToken();
    LocalStorage().saveFCMToken(token: token);
    debugPrint("fcmTokenSet------> $token");
  }



  String? validatePhoneNumberLogin(String? value) {
    if (value != null && value.isNotEmpty) {
      value = value.trim();
      if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
        return StringConstant.kPLeaseEnterValid.tr;
      }
    } else {
      return StringConstant.kPhoneNumberCannotBeEmpty.tr;
    }
    return null;
  }



  void startTimer() {
    secondsRemaining.value = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }
  void resetTimer() {
    startTimer();
  }

  void checkLoginStatus() {
    String? token = LocalStorage().getToken();
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      print("User already logged in ");
    } else {
      isLoggedIn.value = false;
      print("User not logged in ");
    }
  }
  Rx<SendOtpModel> sendOtpModel = SendOtpModel().obs;
  Future<SendOtpModel?> sendOtp(String phoneNumber) async {
    Map<String, dynamic> requestBody = {
      "mobileNumber": phoneNumber,
      "userType": "1",
    };

    try {
      isLoading.value = true;

      final result = await Repository().sendOtpRepo(requestBody);

      if (result != null) {
        sendOtpModel.value = result;
        enteredOtp.value = '';

        appSnackBar(
          title: StringConstant.kSuccess.tr,
          message:
          "${StringConstant.kTestOTP.tr} ${sendOtpModel?.value.data?.otp}",
          backgroundColor: Colors.green,
        );


        print("OTP received: ${sendOtpModel.value.data?.otp}");
      }

      return sendOtpModel.value;
    } catch (e) {
      print("Error in sendOtp: $e");
      return null;
    } finally {
      isLoading.value = false;
    }

  }




  Future<GetTokenModel?> getToken(String phoneNumber) async {
    Map<String, dynamic> requestBody = {
      "mobileNumber": phoneNumber,
      "userType": "1",
      "fcmToken":LocalStorage().getFCMToken()
    };
    print("Calling getToken with $phoneNumber");
    isLoading.value = true;

    try {
      final value = await Repository().getTokens(requestBody);
      print(" Value received in controller token: $value");
      if (value.data?.token != null && value.data!.token!.isNotEmpty) {
        LocalStorage tokenStorage = LocalStorage();
        await tokenStorage.saveToken(value.data!.token!);
        await tokenStorage.saveRefreshToken(value.data!.refreshToken!);
        await tokenStorage.saveUserId(value.data!.id.toString());

        isLoggedIn.value = true;
      }

      getTokenModel = value;
      return value;
    } catch (error) {
      print(" Error in controller get token: $error");
      return null;
    } finally {
      isLoading.value = false;
    }
  }


  Future<GetTokenModel?> refreshToken() async {
    final storedRefreshToken = LocalStorage().getRefreshToken();

    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      print("No refresh token found, user needs to login again.");
      Get.offAllNamed(RouteStrings.welcomeScreen);
      return null;
    }

    Map<String, dynamic> requestBody = {
      "refreshToken": storedRefreshToken,
    };

    print("Calling refreshToken API");
    isLoading.value = true;

    try {
      final response = await Repository().refreshToken(requestBody);
      print("Refresh token response: $response");

      if (response.data?.token != null && response.data!.token!.isNotEmpty) {
        await LocalStorage().saveToken(response.data!.token!);
      }

      if (response.data?.refreshToken != null && response.data!.refreshToken!.isNotEmpty) {
        await LocalStorage().saveRefreshToken(response.data!.refreshToken!);
      }

      isLoggedIn.value = true;
      return response;
    } catch (error) {
      print("Error refreshing token: $error");
      await LocalStorage().removeToken();
      Get.offAllNamed(RouteStrings.welcomeScreen);
      return null;
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> logout() async {
    await LocalStorage().removeToken();
    isLoggedIn.value = false;
    Get.offAllNamed(RouteStrings.welcomeScreen);
  }
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

}
