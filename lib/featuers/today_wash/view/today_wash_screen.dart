import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/widgets/components/app_home_bg.dart';
import 'package:hiwash_worker/widgets/components/doted_vertical_line.dart';
import 'package:hiwash_worker/widgets/components/hi_wash_text_field.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import '../../../generated/assets.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/app_dialog.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/get_start_button.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/is_select_button.dart';
import '../../../widgets/components/profile_image_container.dart';
import '../controller/wash_status_controller.dart';

class TodayWashScreen extends StatelessWidget {
  TodayWashScreen({super.key});

  final WashStatusController controller = Get.put(WashStatusController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
              () =>
          controller.isWashSelected.value
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.heightSizeBox,
                GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AppDialog(
                            margin: EdgeInsets.zero,
                            child: scanDialog());
                      },
                    );
                  },
                  child: todayWashes(),
                ),
                21.heightSizeBox,

                ListView.separated(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 60,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder:
                      (context, index) => 10.heightSizeBox,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return servicesContainer();
                  },
                ),
              ],
            ),
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                15.heightSizeBox,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColor.c5C6B72.withOpacity(
                        0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "05 Jan 2025 – 11 Jan 2025",
                        style: w500_14p(
                          color: AppColor.c2C2A2A,
                        ),
                      ),
                      ImageView(
                        path: Assets.iconsIcDropDown,
                        height: 6,
                        width: 12,
                      ),
                    ],
                  ),
                ),
                /* HiWashTextField(
                                  hintText: "05 Jan 2025 – 11 Jan 2025",
                                  readOnly: false,

                                  style: w500_14p(color: AppColor.c2C2A2A),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ImageView(
                                      path: Assets.iconsIcDropDown,
                                      height: 6,
                                      width: 12,
                                    ),
                                  ),
                                ),*/
                ListView.separated(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 30,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  separatorBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return 15.heightSizeBox;
                  },

                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return dayWashRow();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget servicesContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColor.c142293.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageView(radius: 25, radiusStack: 6),
          15.widthSizeBox,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Elite car wash service",
                  style: w600_14a(color: AppColor.c2C2A2A),
                ),
                10.heightSizeBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IsSelectButton(),
                        5.widthSizeBox,
                        Text(
                          "09-May-2024",
                          style: w400_12a(color: AppColor.c455A64),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 5),
                      child: DotedVerticalLine(height: 10),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IsSelectButton(),
                        5.widthSizeBox,
                        Text(
                          "Buy 1 Get 1 Free ",
                          style: w400_10a(color: AppColor.c455A64),
                        ),
                      ],
                    ),
                  ],
                ),
                7.heightSizeBox,
              ],
            ),
          ),
          Container(
            width: 30,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ImageView(path: Assets.iconsIcStar, height: 14, width: 14),

                Text("4.5", style: w400_10a(color: AppColor.c455A64)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget todayWashes() {
    return Container(
      height: 151,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 18, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageView(path: Assets.iconsTodayCar, height: 59, width: 107),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "53",
                      style: w700_27a(
                        color: AppColor.white,
                      ).copyWith(fontSize: 47),
                    ),
                    3.widthSizeBox,
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Today Washes",
                        style: w500_16p(color: AppColor.white.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            child: Row(
              children: [
                Container(
                  width: 2,
                  height: 151,
                  color: AppColor.white.withOpacity(0.12),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 19, top: 10),
                      child: Column(
                        children: [
                          Text("29", style: w500_24a(color: AppColor.white)),
                          Text(
                            "Complete",
                            style: w500_12p(
                              color: AppColor.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 2,
                      width: 100,
                      color: AppColor.white.withOpacity(0.1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 19, bottom: 10),
                      child: Column(
                        children: [
                          Text("19", style: w500_24a(color: AppColor.white)),
                          Text(
                            "kRemaining".tr,
                            style: w500_12p(
                              color: AppColor.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget washLogRow() {
    return Row(
      children: [
        15.widthSizeBox,
        ProfileImageView(radius: 20, radiusStack: 4),

        11.widthSizeBox,
        Expanded(
          child: Text(
            "Elite car wash service",
            style: w600_12a(color: AppColor.c2C2A2A),
          ),
        ),
        Container(
          width: 50,
          child: Text("10:25 AM", style: w400_12a(color: AppColor.c2C2A2A)),
        ),
        20.widthSizeBox,
        Container(
          padding: EdgeInsets.only(right: 15),
          child: Row(
            children: [
              Text("4.5", style: w400_10a(color: AppColor.c455A64)),
              2.widthSizeBox,
              ImageView(path: Assets.iconsIcStar, height: 10, width: 10),
            ],
          ),
        ),
        10.widthSizeBox,
      ],
    );
  }

  Widget rowDivider() {
    return Column(
      children: [10.heightSizeBox, DotedHorizontalLine(), 10.heightSizeBox],
    );
  }

  Widget dayWashRow() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 14),
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColor.c142293.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 5,
                separatorBuilder: (BuildContext context, int index) {
                  return rowDivider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return washLogRow();
                },
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColor.c142293.withOpacity(0.10)),
            /* boxShadow: [
              BoxShadow(
                color: AppColor.c142293.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],*/
          ),
          child: Text("06 Jan 2025", style: w500_10p()),
        ),
      ],
    );
  }

  Widget scanDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        37.heightSizeBox,
      Stack(
        alignment: Alignment.topRight,
        children: [
          Container(

            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColor.blue.withOpacity(0.2)),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Assets.imagesDemoProfile),
            ),
          ),
           Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColor.cE8E9F4),
            ),

            child:CircleAvatar(
              radius: 10,
              backgroundImage: AssetImage(Assets.iconsIcCrown),

            ),

          ),
        ],
      ),
        11.heightSizeBox,

        Text(
          "Ibrahim Bafqia",
          style: w700_16a(color: AppColor.c2C2A2A),
          textAlign: TextAlign.center,
        ),

        15.heightSizeBox,
        subscriptionRowWidget(title: 'Pack Name', packName: ' Unlimited Washes'),
        10.heightSizeBox,
        DotedHorizontalLine(),
        10.heightSizeBox,
        subscriptionRowWidget(title: 'Expiry date ', packName: ' 15 Oct 2025'),
        10.heightSizeBox,
        DotedHorizontalLine(),
        10.heightSizeBox,
        subscriptionRowWidget(title: 'Car Number', packName: 'I35·VQD'),
        10.heightSizeBox,
        DotedHorizontalLine(),
        10.heightSizeBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Reward", style: w400_12p(color: AppColor.c455A64)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(

                border: Border.all(color: AppColor.cD83030),
                
                borderRadius: BorderRadius.circular(40)
              ),
              child: Row(

                children: [
                  ImageView(
                    path: Assets.iconsIcQr,
                    height: 14,
                    width: 14,
                  ),
                  7.widthSizeBox,
                  Text("Scan Offer",style: w500_12a(color: AppColor.c142293),),
                ],
              ),
            )
          ],
        ),


        32.heightSizeBox,
        DotedHorizontalLine(),
        52.heightSizeBox,
        GetStartButton(

          text: 'Complete Wash',color: AppColor.c1F9D70,

        boxShadowColor: AppColor.c1F9D70.withOpacity(0.40),
        ),






        46.heightSizeBox,
      ],
    );



  }

  Widget subscriptionRowWidget({
    required String title,
    Color? color,
    required String packName,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.tr, style: w400_12p(color: AppColor.c455A64)),
        Text(packName.tr, style: w500_12p(color: color ?? AppColor.c2C2A2A)),
      ],
    );
  }
}
