// qr_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/styling/app_color.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../generated/assets.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/app_dialog.dart';
import '../../../widgets/components/custom_swipe_button.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/doted_vertical_line.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/is_select_button.dart';
import '../../../widgets/components/profile_image_container.dart';
import '../../../widgets/components/star_rating.dart';
import '../controller/qr_controller.dart';

class QrScreen extends StatelessWidget {
  QrScreen({super.key});

  final QrController controller = Get.put(QrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cF6F7FF.withOpacity(0.2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: controller.clearScan,
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Container(
              alignment: Alignment.center,
              width: Get.width / 1.2,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QRView(
                    
                    key: controller.qrKey,
                    onQRViewCreated: controller.onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      overlayColor: AppColor.c101D8D.withOpacity(0.5),
                      borderRadius: 10,
                      borderLength: 50,
                      borderWidth: 20,
                      cutOutSize: 300,
                    ),
                  ),
                  Obx(() => controller.scanUrl.value.isEmpty
                      ? AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: controller.animation.value,
                        child: Container(
                          width: 280,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColor.cFFC727,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      );
                    },
                  )
                      : SizedBox.shrink()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Obx(() => Column(
            children: [
              Text(
                controller.customerId.value.isNotEmpty
                    ? 'Customer ID: ${controller.customerId.value}'
                    : 'Scan a QR code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              if (controller.internetStatus.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    controller.internetStatus.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          )),
        ],
      ),
    );
  }
  Widget scanDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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

                    child: CircleAvatar(
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
              subscriptionRowWidget(
                title: 'Pack Name',
                packName: ' Unlimited Washes',
              ),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(
                title: 'Expiry date ',
                packName: ' 15 Oct 2025',
              ),
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

                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        ImageView(
                          path: Assets.iconsIcQr,
                          height: 14,
                          width: 14,
                        ),
                        7.widthSizeBox,
                        Text(
                          "Scan Offer",
                          style: w500_12a(color: AppColor.c142293),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              32.heightSizeBox,
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.cF6F7FF,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              DotedHorizontalLine(),

              52.heightSizeBox,
              GestureDetector(
                onTap: () {
                  Get.back();
                  showDialog(
                    barrierDismissible: false,
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return AppDialog(
                        padding: EdgeInsets.zero,
                        //  margin: EdgeInsets.only(left: 16,right: 16,bottom: ),
                        child: scannedWithImageDialog(),
                      );
                    },
                  );
                },
                child: ImageView(path: Assets.demoWorkerLicense, height: 144),
              ),
              30.heightSizeBox,

              /*     SwipeButton(
                  activeTrackColor: AppColor.c1F9D70,
                activeThumbColor: AppColor.c1F9D70,
                thumbPadding: EdgeInsets.all(3),
                thumb: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
                elevationThumb: 2,
                elevationTrack: 2,
                child: Text(
                  "Swipe to ...".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onSwipe: () {
                  ScaffoldMessenger.of(Get.context!).showSnackBar(
                    SnackBar(
                      content: Text("Swipped"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              )*/
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSwipeButton(
                    thumbPadding: EdgeInsets.all(3),
                    activeThumbColor: AppColor.c1F9D70,
                    thumb: Icon(Icons.chevron_right, color: Colors.white),
                    elevationThumb: 2,
                    elevationTrack: 2,
                    child: Text(
                      "Swipe to Complete Wash ".toUpperCase(),
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onSwipe: () {
                      /* ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text("Swiped!"),
                          backgroundColor: Colors.green,
                        ),
                      );*/
                      Get.back();
                      showDialog(
                        barrierDismissible: false,
                        context: Get.context!,
                        builder: (BuildContext context) {
                          return AppDialog(
                            padding: EdgeInsets.zero,

                            child: scannedWithImageDialog(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              /*   GetStartButton(
                text: 'Complete Wash',
                color: AppColor.c1F9D70,

                boxShadowColor: AppColor.c1F9D70.withOpacity(0.40),
              ),*/
              46.heightSizeBox,
            ],
          ),
        ),
      ],
    );
  }

  Widget scannedWithImageDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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

                    child: CircleAvatar(
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
              subscriptionRowWidget(
                title: 'Pack Name',
                packName: ' Unlimited Washes',
              ),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(
                title: 'Expiry date ',
                packName: ' 15 Oct 2025',
              ),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(title: 'Car Number', packName: 'I35·VQD'),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(
                title: 'Reward',
                packName: 'Flat 30% off',
                color: AppColor.c1F9D70,
              ),

              32.heightSizeBox,
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.cF6F7FF,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              DotedHorizontalLine(),

              30.heightSizeBox,
              ImageView(path: Assets.demoNumberPlate, height: 155),
              30.heightSizeBox,

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSwipeButton(
                    thumbPadding: EdgeInsets.all(3),
                    activeThumbColor: AppColor.c1F9D70,
                    thumb: Icon(Icons.chevron_right, color: Colors.white),
                    elevationThumb: 2,
                    elevationTrack: 2,
                    child: Text(
                      "Swipe to Complete Wash ".toUpperCase(),
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onSwipe: () {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text("Swiped!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Get.back();
                      showDialog(
                        barrierDismissible: false,
                        context: Get.context!,
                        builder: (BuildContext context) {
                          return AppDialog(
                            topVisible: true,

                            padding: EdgeInsets.zero,

                            child: ownerDetailsDialog(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              /*   GetStartButton(
                text: 'Complete Wash',
                color: AppColor.c1F9D70,

                boxShadowColor: AppColor.c1F9D70.withOpacity(0.40),
              ),*/
              46.heightSizeBox,
            ],
          ),
        ),
      ],
    );
  }

  Widget ownerDetailsDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              37.heightSizeBox,
              ProfileImageView(radius: 50, isVisibleStack: false),
              11.heightSizeBox,

              Text(
                "Ibrahim Bafqia",
                style: w700_16a(color: AppColor.c2C2A2A),
                textAlign: TextAlign.center,
              ),

              15.heightSizeBox,
              subscriptionRowWidget(
                title: 'Pack Name',
                packName: ' Unlimited Washes',
              ),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(
                title: 'Expiry date ',
                packName: ' 15 Oct 2025',
              ),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(title: 'Car Number', packName: 'I35·VQD'),
              10.heightSizeBox,
              DotedHorizontalLine(),
              10.heightSizeBox,
              subscriptionRowWidget(
                title: 'Reward',
                packName: 'Flat 30% off',
                color: AppColor.c1F9D70,
              ),

              32.heightSizeBox,
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomSwipeButton(
              thumbPadding: EdgeInsets.all(3),
              activeThumbColor: AppColor.c1F9D70,
              thumb: Icon(Icons.chevron_right, color: Colors.white),
              elevationThumb: 2,
              elevationTrack: 2,
              child: Text(
                "Swipe to Complete Wash ".toUpperCase(),
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onSwipe: () {
                /* ScaffoldMessenger.of(Get.context!).showSnackBar(
                  SnackBar(
                    content: Text("Swiped!"),
                    backgroundColor: Colors.green,
                  ),*/
                Get.back();
                showDialog(
                  barrierDismissible: false,
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return AppDialog(
                      bottomVisible: true,

                      padding: EdgeInsets.zero,

                      child: successDialog(),
                    );
                  },
                );
              },
            ),
          ),
        ),
        30.heightSizeBox,
      ],
    );
  }

  Widget successDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              30.heightSizeBox,
              Container(
                width: Get.width,

                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ImageView(
                        path: Assets.imagesImSussess,
                        width: Get.width,
                        height: 180,
                      ),
                    ),
                  ],
                ),
              ),
              21.heightSizeBox,
              Text("Wash Complete! ", style: w700_22a(color: AppColor.c2C2A2A)),
              Text(
                "Share your feedback and\nrate the Customer.",
                textAlign: TextAlign.center,
                style: w400_16p(),
              ),
              9.heightSizeBox,
              StarRating(rating: 4),
              15.heightSizeBox,
              TextFormField(
                maxLines: 3,
                style: w400_14p(color: AppColor.c2C2A2A.withOpacity(0.9)),
                decoration: InputDecoration(
                  fillColor: AppColor.white,
                  hintText: "Enter your comment here...",
                  //  labelText: "Address",
                  filled: true,
                  //  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: w400_13a(color: AppColor.c455A64),
                  hintStyle: w400_14p(
                    color: AppColor.c2C2A2A.withOpacity(0.40),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.cEAE8E8.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.c5C6B72.withOpacity(0.30),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.c5C6B72.withOpacity(0.30),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.c5C6B72.withOpacity(0.30),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.c5C6B72.withOpacity(0.30),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.c5C6B72.withOpacity(0.30),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              15.heightSizeBox,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColor.c142293,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.c142293.withOpacity(0.30),
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text("Submit", style: w500_14a(color: AppColor.white)),
                ),
              ),
              18.heightSizeBox,
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.cF6F7FF,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              DotedHorizontalLine(),

              Padding(
                padding: EdgeInsets.only(top: 23, left: 19, bottom: 23),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ProfileImageView(radius: 20, radiusStack: 4),
                    9.widthSizeBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ibrahim Bafqia",
                          style: w600_14a(color: AppColor.c2C2A2A),
                        ),
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
                          child: DotedVerticalLine(height: 5),
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
                  ],
                ),
              ),
              40.heightSizeBox,
            ],
          ),
        ),
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
