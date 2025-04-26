import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }


  Future<SendOtpModel?> sendOtp(String phoneNumber) async {
    Map<String, dynamic> requestBody = {
      "mobileNumber": phoneNumber,
      "userType": "1",
    };
  try{
    isLoading.value = true;
    sendOtpModel = await Repository().sendOtpRepo(requestBody);
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
      getTokenModel = value;
      LocalStorage token = LocalStorage();
      token.saveToken(value.data?.token ?? '');

      return value;
    } catch (error) {
      print(" Error in controller send otp: $error");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<SignUpModel?> signUp(
      String fullName,
      String phoneNumber,
      String email,
      String zone,
      String street,
      String building,
      String unit,
      ) async {
    Map<String, dynamic> requestBody = {
      "fullName": fullName,
      "email": email,
      "mobileNumber": phoneNumber,
      "zone": zone,
      "street": street,
      "building": building,
      "unit": unit,
      "userType": "1",
    };
    print("Calling getToken with $phoneNumber");
    isLoading.value = true;

    try {
      signUpModel = await Repository().signUp(requestBody);
      print(" Value received in controller: $signUpModel");

      return signUpModel;
    } catch (error) {
      print(" Error in controller send otp: $error");
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
