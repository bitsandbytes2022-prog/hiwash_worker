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
                  onTap: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      String phoneNumber = controller.loginPhoneController.text.trim();
                  await    controller.sendOtp(phoneNumber).then((value) {
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


              54.heightSizeBox,



              30.heightSizeBox,
            ],
          ),
        ),
      ),
    );
  }
}
