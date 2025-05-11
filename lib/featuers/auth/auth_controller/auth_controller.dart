import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../../../route/route_strings.dart';
import '../../../styling/app_color.dart';
import '../model/get_token_model.dart';
import '../model/send_otp_model.dart';
import '../model/sign_up_model.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    pageController.addListener(() {
      onPageChanged(pageController.page!.round());
    });
    checkLoginStatus();
    super.onInit();
  }

  GetTokenModel? getTokenModel;
  SendOtpModel? sendOtpModel;
  SignUpModel? signUpModel;

  /// login controller
  TextEditingController loginPhoneController = TextEditingController(
    text: "6446544689",
  );


  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  /// Welcome screen
  final PageController pageController = PageController();

  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }






  String? validatePhoneNumberLogin(String? value) {
    if (value != null && value.isNotEmpty) {
      value = value.trim();
      if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
        return "Please Enter Valid Phone Number";
      }
    } else {
      return "Phone number cannot be empty";
    }
    return null;
  }


  var isLoading = false.obs;
  var enteredOtp = ''.obs;
  var secondsRemaining = 30.obs;
  Timer? _timer;

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
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
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
  Future<SendOtpModel?> sendOtp(String phoneNumber) async {
    Map<String, dynamic> requestBody = {
      "mobileNumber": phoneNumber,
      "userType": "1",
    };
  try{
    isLoading.value = true;
    sendOtpModel = await Repository().sendOtpRepo(requestBody);
    Get.snackbar(
      'Success',
      "OTP: ${sendOtpModel?.data?.otp}",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: AppColor.white,
    );
    print("Value received in controller sendOtp: $sendOtpModel");
    return sendOtpModel;
  }catch(e){
    print("Error in controller while sending OTP: $e");
    return null;
  }finally{
    isLoading.value = false;
  }

  }
  Future<GetTokenModel?> getToken(String phoneNumber) async {
    Map<String, dynamic> requestBody = {
      "mobileNumber": phoneNumber,
      "userType": "1",
    };
    print("Calling getToken with $phoneNumber");
    isLoading.value = true;

    try {
      final value = await Repository().getTokens(requestBody);
      print(" Value received in controller token: $value");
      if (value.data?.token != null && value.data!.token!.isNotEmpty) {
        LocalStorage tokenStorage = LocalStorage();
        await tokenStorage.saveToken(value.data!.token!);
        await tokenStorage.saveUserId(value.data!.id.toString());

        isLoggedIn.value = true;
      }

      getTokenModel = value;
      return value;
    } catch (error) {
      print(" Error in controller send otp: $error");
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

}
