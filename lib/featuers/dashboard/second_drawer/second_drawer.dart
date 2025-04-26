import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hiwash_worker/featuers/dashboard/second_drawer/second_drawer_controller/second_drawer_controller.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../generated/assets.dart';
import '../../../../styling/app_color.dart';
import '../../../../styling/app_font_anybody.dart';
import '../../../../widgets/components/doted_horizontal_line.dart';
import '../../../../widgets/components/doted_vertical_line.dart';
import '../../../../widgets/components/image_view.dart';
import '../../../route/route_strings.dart';
import 'chat_screen.dart';

class SecondDrawer extends StatelessWidget {
  SecondDrawer({super.key});

  final SecondDrawerController controller = Get.put(SecondDrawerController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          48.heightSizeBox,
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Align(
                alignment: Alignment.topRight,
                child: ImageView(
                  path: Assets.iconsIcClose,
                  height: 28,
                  width: 32,
                ),
              ),
            ),
          ),
          ImageView(path: Assets.imagesHelpSupport, height: 180),
          31.heightSizeBox,
          Text("Get Help?", style: w700_22a()),
          40.heightSizeBox,

          /// **Drawer Options**
          drawerRowWidget(
            onTap: () async {
              String url =
                  "https://tawk.to/chat/68066e7b2db46a190e068251/1ipchv5dp";
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
            title: 'Chat with Support',
            image: Assets.iconsIcChat,
          ),
          drawerRowWidget(
            onTap: () => Get.toNamed(RouteStrings.helpDeskTicketScreen),
            title: 'Help Desk Ticket',
            image: Assets.iconsIcTicket,
          ),
          drawerRowWidget(
            onTap: () {
              //await controller.getFaq();
              Get.toNamed(RouteStrings.faqScreen);
            },
            title: 'FAQ’s',
            image: Assets.iconsIcFaq,
          ),
          /*   drawerRowWidget(
            onTap: () => Get.toNamed(RouteStrings.faqScreen),
            title: 'FAQ’s',
            image: Assets.iconsIcFaq,
          ),*/
          drawerRowWidget(
            onTap: () {
              Get.toNamed(RouteStrings.stepByStepGuideScreen);
            },
            title: 'Step-by-Step Guide',
            dashedLineWidget: false,
            image: Assets.iconsIcGuideBook,
          ),

          Spacer(),
          DotedHorizontalLine(),
          Container(
            color: AppColor.cF6F7FF,
            alignment: Alignment.center,
            height: 86,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageView(height: 23, width: 23, path: Assets.iconsPhone),
                      Text("+974 7048 7070", style: w500_12a()),
                    ],
                  ),
                ),
                DotedVerticalLine(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageView(
                        height: 23,
                        width: 23,
                        path: Assets.iconsIcAtSign,
                      ),
                      Text("info@hiwash.com", style: w500_12a()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerRowWidget({
    required VoidCallback onTap,
    required String title,
    bool dashedLineWidget = true,
    required String image,
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
          dashedLineWidget ? DotedHorizontalLine() : SizedBox(),
          18.heightSizeBox,
        ],
      ),
    );
  }
}
