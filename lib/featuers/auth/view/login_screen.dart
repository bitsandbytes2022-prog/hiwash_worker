import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hiwash_worker/featuers/auth/view/auth_controller/auth_controller.dart';
import 'package:hiwash_worker/widgets/components/app_bg.dart';
import 'package:hiwash_worker/widgets/components/hi_wash_text_field.dart';
import 'package:hiwash_worker/widgets/components/image_view.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';

import '../../../generated/assets.dart';
import '../../../route/route_strings.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../widgets/components/bottom_sheet_bg.dart';
import '../../../widgets/components/hi_wash_button.dart';
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
        showBackButton: false,
        child: Form(
          key: formKey,
          child: Container(
            height: Get.height*0.60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                114.heightSizeBox,
                HiWashTextField(
                  keyboardType: TextInputType.emailAddress,

                  hintText: "kEmail".tr,
                  labelText: "kEmail".tr,

                  validator: (value) {
                    return controller.validateEmail(value);
                  },
                ),
                24.heightSizeBox,
                HiWashTextField(
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "kPassword".tr,
                  labelText: "kPassword".tr,

                  validator: (value) {
                    return controller.validatePassword(value);
                  },
                ),
                56.heightSizeBox,

                HiWashButton(
                  text: "kLogIn".tr,
                  onTap: () {
                    Get.offNamed(RouteStrings.dashboardScreen);
                  },
                ),
                175.heightSizeBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
