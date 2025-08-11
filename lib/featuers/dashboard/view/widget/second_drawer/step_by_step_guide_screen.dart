import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hiwash_worker/featuers/dashboard/view/widget/second_drawer/second_drawer_controller/second_drawer_controller.dart';
import 'package:hiwash_worker/language/String_constant.dart';

import 'package:hiwash_worker/widgets/components/app_home_bg.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';

import '../../../../../generated/assets.dart';
import '../../../../../route/route_strings.dart';
import '../../../../../styling/app_color.dart';
import '../../../../../styling/app_font_poppins.dart';
import '../../../../../widgets/components/doted_horizontal_line.dart';
import '../../../../../widgets/components/image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/featuers/dashboard/view/widget/second_drawer/second_drawer_controller/second_drawer_controller.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/widgets/components/app_home_bg.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import '../../../../../generated/assets.dart';
import '../../../../../route/route_strings.dart';
import '../../../../../styling/app_color.dart';
import '../../../../../styling/app_font_poppins.dart';
import '../../../../../widgets/components/doted_horizontal_line.dart';
import '../../../../../widgets/components/image_view.dart';

class StepByStepGuideScreen extends StatelessWidget {
  /// If true -> show AppHomeBg wrapper (heading, top bar, etc).
  /// If false -> show plain Column layout (for bottom nav).
  final bool showAppHomeBg;

  StepByStepGuideScreen({Key? key, this.showAppHomeBg = false}) : super(key: key);

  // Controller (keeps existing logic)
  final SecondDrawerController secondDrawerController =
  Get.isRegistered<SecondDrawerController>()
      ? Get.find()
      : Get.put(SecondDrawerController());

  @override
  Widget build(BuildContext context) {
    final argValue = (Get.arguments is Map) ? (Get.arguments as Map)['showAppHomeBg'] : null;
    final bool useAppBg = argValue == true || showAppHomeBg;

    if (secondDrawerController.guidesResponseModel.value == null ||
        (secondDrawerController.guidesResponseModel.value?.data?.isEmpty ?? true)) {
      secondDrawerController.getGuides();
    }

    Widget content = Column(
      children: [
        15.heightSizeBox,
        ListView.separated(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: secondDrawerController.guidesResponseModel.value?.data?.length ?? 0,
          separatorBuilder: (context, index) => DotedHorizontalLine(),
          itemBuilder: (context, index) {
            final item = secondDrawerController.guidesResponseModel.value?.data?[index];
            return countryRow(
              title: item?.category ?? "",
              description: item?.description ?? "",
            );
          },
        ),
      ],
    );
    if (useAppBg) {
      return AppHomeBg(
          padding: EdgeInsets.zero,
          headingText: StringConstant.kStepByStepGuide.tr,
          iconRight: SizedBox(),
          child: Column(
            children: [
              15.heightSizeBox,
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),

                shrinkWrap: true,
                itemCount: secondDrawerController.guidesResponseModel.value?.data
                    ?.length ?? 0,

                separatorBuilder: (context, index) {

                  return  DotedHorizontalLine();
                },
                itemBuilder: (context, index) {
                  final item = secondDrawerController.guidesResponseModel.value?.data?[index];
                  return countryRow(
                    title: item?.category ?? "",
                    description: item?.description ?? "",
                  );
                },
              )



            ],
          )
      );
    } else {
      return Column(
        children: [
          15.heightSizeBox,
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),

            shrinkWrap: true,
            itemCount: secondDrawerController.guidesResponseModel.value?.data
                ?.length ?? 0,

            separatorBuilder: (context, index) {

              return  DotedHorizontalLine();
            },
            itemBuilder: (context, index) {
              final item = secondDrawerController.guidesResponseModel.value?.data?[index];
              return countryRow(
                title: item?.category ?? "",
                description: item?.description ?? "",
              );
            },
          )



        ],
      );

    }
  /*  if (useAppBg) {
      return AppHomeBg(
        padding: EdgeInsets.zero,
        headingText: StringConstant.kStepByStepGuide.tr,
        iconRight: SizedBox(),
        child: content,
      );
    } else {
      // Plain column when coming from bottom navigation
      return content;
    }*/
  }

  countryRow({required String title, required String description}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteStrings.stepByStepGuideDetailScreen, arguments: {
          'title': title,
          'description': description,
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title.tr, style: w500_14p(color: AppColor.c2C2A2A)),
              ImageView(
                path: Assets.iconsBlackForwardArrow,
                height: 10,
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
class StepByStepGuideScreen extends StatelessWidget {
  StepByStepGuideScreen({super.key});

  SecondDrawerController secondDrawerController =Get.isRegistered<SecondDrawerController>()?Get.find():Get.put(SecondDrawerController());

  @override
  Widget build(BuildContext context) {
    secondDrawerController.getGuides();

    return Column(
      children: [
        15.heightSizeBox,
        ListView.separated(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),

          shrinkWrap: true,
          itemCount: secondDrawerController.guidesResponseModel.value?.data
              ?.length ?? 0,

          separatorBuilder: (context, index) {

            return  DotedHorizontalLine();
          },
          itemBuilder: (context, index) {
            final item = secondDrawerController.guidesResponseModel.value?.data?[index];
            return countryRow(
              title: item?.category ?? "",
              description: item?.description ?? "",
            );
          },
        )



      ],
    );

    */
/*AppHomeBg(
        padding: EdgeInsets.zero,
        headingText: StringConstant.kStepByStepGuide.tr,
        iconRight: SizedBox(),
        child: Column(
          children: [
            15.heightSizeBox,
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),

              shrinkWrap: true,
              itemCount: secondDrawerController.guidesResponseModel.value?.data
                  ?.length ?? 0,

              separatorBuilder: (context, index) {

                return  DotedHorizontalLine();
              },
              itemBuilder: (context, index) {
                final item = secondDrawerController.guidesResponseModel.value?.data?[index];
                return countryRow(
                  title: item?.category ?? "",
                  description: item?.description ?? "",
                );
              },
            )



          ],
        )
    );*//*

  }

  countryRow({required String title,required String description}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteStrings.stepByStepGuideDetailScreen, arguments: {
          'title': title,
          'description': description,
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 5,bottom: 5),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(title.tr, style: w500_14p(color: AppColor.c2C2A2A),),
              ImageView(

                path: Assets.iconsBlackForwardArrow,
                height: 10,
                width: 8,
              )

            ],
          ),
        ),
      ),
    );
  }
}
*/
