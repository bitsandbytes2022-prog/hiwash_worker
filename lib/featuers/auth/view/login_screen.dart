import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:hiwash_worker/widgets/sized_box_extension.dart';

import '../../../generated/assets.dart';
import '../../../route/route_strings.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../widgets/components/app_bg.dart';
import '../../../widgets/components/bottom_sheet_bg.dart';
import '../../../widgets/components/hi_wash_button.dart';
import '../../../widgets/components/hi_wash_text_field.dart';
import '../auth_controller/auth_controller.dart';
import 'auth_widgets/bg_widget.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: AppBg(
        headingText: "kWelcomeBack".tr,
        subText: "kLogin".tr,

        showBackButton: true,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              114.heightSizeBox,
              HiWashTextField(
                controller: controller.loginPhoneController,
                keyboardType: TextInputType.phone,

                hintText: "Phone".tr,
                labelText: "Phone".tr,

                validator: (value) {
                  return controller.validatePhoneNumberLogin(value);
                },
              ),
              /*     12.heightSizeBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteStrings.forgotPasswordScreen);
                    },
                    child: Text(
                      "kForgotPassword".tr,
                      style: w500_14a(color: AppColor.red),
                    ),
                  ),
                ],
              ),*/
              104.heightSizeBox,
              Obx(() {
                return HiWashButton(
                  isLoading: controller.isLoading.value,
                  text: "kLogIn".tr,
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      String phoneNumber = controller.loginPhoneController.text.trim();
                      controller.sendOtp(phoneNumber).then((value) {
                        if (value != null) {
                          Get.toNamed(
                            RouteStrings.loginOtpScreen,
                            arguments: phoneNumber,
                          );
                          controller.loginPhoneController.clear();
                        }
                      }).catchError((error) {
                        print("Error during OTP sending: $error");
                      });
                    }
                  },
                );
              }),
              /*    Obx(() {
               return HiWashButton(
                  isLoading: controller.isLoading.value,
                  text: "kLogIn".tr,
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      String phoneNumber = controller.loginPhoneController.text.trim();
                      controller.sendOtp(phoneNumber).then((value) {
                        if (value != null) {
                          Get.toNamed(
                            RouteStrings.loginOtpScreen,
                            arguments: phoneNumber,
                          );
                          controller.loginPhoneController.clear();
                        }
                      });
                    }
                  },
                );
              }),*/

              54.heightSizeBox,

              /*  Center(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "kDontAaveAccount".tr,
                        style: w400_12a(color: AppColor.c455A64),
                      ),
                      TextSpan(
                        text: "SIGNUP".tr,
                        style: w500_14a(color: AppColor.red),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Get.back();
                                Get.toNamed(RouteStrings.signUpScreen);
                                print("Sign Up tapped");
                              },
                      ),
                    ],
                  ),
                ),
              ),
              18.heightSizeBox,*/

              30.heightSizeBox,
            ],
          ),
        ),
      ),
    );
  }
}
