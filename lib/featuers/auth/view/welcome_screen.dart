import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/featuers/auth/view/auth_widgets/bg_widget.dart';
import 'package:hiwash_worker/generated/assets.dart';
import 'package:hiwash_worker/widgets/components/get_start_button.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../route/route_strings.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../widgets/components/bottom_sheet_bg.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            children: [
               BgWidget(imagePath: Assets.imagesWelcomeBg),

            ],
          ),

          Positioned(
            bottom: 0,
            child: Container(
              child: BottomSheetBg(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    110.heightSizeBox,
                    Text(
                      "Elite car wash service",
                      style: w700_22a(color: AppColor.c2C2A2A),
                    ),
                    15.heightSizeBox,
                    Text(
                      'Earn more, get rewards, and enjoy exclusive worker benefits!',
                      textAlign: TextAlign.center,
                      style: w400_16a(color: AppColor.c455A64),
                    ),
                    33.heightSizeBox,
                    SmoothPageIndicator(
                      controller: _pageController, // PageController
                      count: 3, // Number of dots
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColor.red,
                        dotColor: Colors.grey,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                      ),
                    ),
                    30.heightSizeBox,
                    GetStartButton(
                      width: 193,
                      text: "kGetStarted".tr,
                      onTap: () {
                        Get.toNamed(RouteStrings.loginScreen);
                      },
                    ),
                    15.heightSizeBox,
                    Text(
                      "kTermsAndConditions".tr,
                      style: w500_14a(color: AppColor.red),
                    ),
                    60.heightSizeBox,
                  ],
                ),
              ),
            ),
          ),

          //  Text("Skip"),
        ],
      ),
    );
  }
}
