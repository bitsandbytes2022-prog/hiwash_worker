import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hiwash_worker/widgets/components/app_home_bg.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';

import '../../../generated/assets.dart';
import '../../../route/route_strings.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/doted_vertical_line.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/profile_image_container.dart';
import '../../profile/view/chat_screen.dart';
import '../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  NotificationController controller = Get.put(NotificationController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        /*    Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColor.cC31848,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.cC31848.withOpacity(0.30),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: AppColor.c000000.withOpacity(0.1),
                            ),
                          ),
                          child: ImageView(
                            path: Assets.iconsIcBook,
                            height: 24,
                            width: 24,
                            color: AppColor.white,
                          ),
                        ),
                        10.widthSizeBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "kYourCurrentLocation".tr,
                              style: w400_12a(color: AppColor.c455A64),
                            ),
                            Text(
                              "2847 Poling Farm Road",
                              style: w500_14p(color: AppColor.c000000),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 8),
                          child: ImageView(
                            path: Assets.iconsIcForward,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    ),
                  ),*/
        1 .heightSizeBox,

        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: 20,
          separatorBuilder: (context, index) {
            return  DotedHorizontalLine();
          },
          itemBuilder: (context, index) {
            return Obx(() {
              return notificationContainer(index);
            });
          },
        ),
      ],
    );
  }

  Widget drawerRowWidget({
    required VoidCallback onTap,
    required String title,
    bool dashedLineWidget = true,
    required String image
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 18, right: 12),
            child: Row(
              children: [
                ImageView(path: image, height: 20, width: 20),
                10.widthSizeBox,
                Text(title, style: w500_14a(color: AppColor.c2C2A2A)),
                Spacer(),
                ImageView(
                  path: Assets.iconsBlackForwardArrow,
                  height: 13,
                  width: 13,
                ),
              ],
            ),
          ),
          18.heightSizeBox,
          dashedLineWidget ?  DotedHorizontalLine(): SizedBox(),
          18.heightSizeBox,
        ],
      ),
    );
  }

  Widget notificationContainer(int index) {
    return GestureDetector(
      onTap: () {
        controller.toggleSelection(index);
      },
      child: Container(
        width: Get.width,
        color:
            controller.selectedIndices[index] ? Colors.white : AppColor.cF6F7FF,
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 26),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImageView(isVisibleStack: false,),
           /* Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColor.c142293.withOpacity(0.1)),
              ),
              child: Container(
                height: 34,
                width: 34,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.c142293.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(Assets.imagesDemoProfile),
                  // Set your image here
                  radius: 20,
                ),
              ),
            ),*/
            9.widthSizeBox,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "kDemoText".tr,
                    style: w500_12p(color: AppColor.c2C2A2A),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  4.heightSizeBox,
                  Text("12 am", style: w400_10p(color: AppColor.c455A64)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

