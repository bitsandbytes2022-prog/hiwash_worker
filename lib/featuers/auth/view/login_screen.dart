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
import 'auth_controller/auth_controller.dart';
import 'auth_widgets/bg_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  AuthController authController = Get.put(AuthController());

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
                keyboardType: TextInputType.phone,
                controller: authController.employeeIdController,
                hintText: "Employee ID".tr,
                labelText: "Employee ID".tr,

                validator: (value) {
                  return authController.validateEmpID(value);
                },
              ),
              24.heightSizeBox,
              HiWashTextField(
                controller: authController.passwordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: "kPassword".tr,
                labelText: "kPassword".tr,

                validator: (value) {
                  return authController.validatePassword(value);
                },
              ),
              80.heightSizeBox,

              HiWashButton(
                text: "kLogIn".tr,
                onTap: () {
                  //Get.offNamed(RouteStrings.dashboardScreen);
                  if (formKey.currentState?.validate() ?? false) {
                    Get.offNamed(RouteStrings.dashboardScreen);
                  }
                },
              ),
              140.heightSizeBox,
            ],
          ),
        ),
      ),
    );
  }
}
