import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/featuers/dashboard/controller/dashboard_controller.dart';
import 'package:hiwash_worker/route/route_strings.dart';
import 'package:hiwash_worker/widgets/components/doted_vertical_line.dart';

import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../generated/assets.dart';
import '../../../network_manager/local_storage.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/app_dialog.dart';
import '../../../widgets/components/custom_swipe_button.dart';
import '../../../widgets/components/data_formet.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/is_select_button.dart';
import '../../../widgets/components/profile_image_container.dart';
import '../../../widgets/components/star_rating.dart';
import '../../qr_scanner/controller/qr_controller.dart';
import '../controller/wash_status_controller.dart';

class TodayWashScreen extends StatelessWidget {
  TodayWashScreen({super.key});

  final WashStatusController controller = Get.put(WashStatusController());
  DashboardController dashboardController = Get.find();
  final QrController qrController = Get.isRegistered<QrController>()?Get.find():Get.put(QrController());

  @override
  Widget build(BuildContext context) {
    var todayWashListData =
        controller.todayWashSummaryModel.value?.data?.summary;
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
                          child: todayWashes(
                            todayWashListData?.totalWashes.toString(),
                            todayWashListData?.remaining.toString(),
                            todayWashListData?.completed.toString(),
                          ),
                        ),
                        21.heightSizeBox,
                        (controller.todayWashSummaryModel.value?.data?.washes !=
                                    null &&
                                controller
                                    .todayWashSummaryModel
                                    .value!
                                    .data!
                                    .washes!
                                    .isNotEmpty)
                            ? ListView.separated(
                              padding: EdgeInsets.only(top: 0, bottom: 40),
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 15),
                              shrinkWrap: true,
                              itemCount:
                                  controller
                                      .todayWashSummaryModel
                                      .value!
                                      .data!
                                      .washes!
                                      .length,
                              itemBuilder: (context, index) {
                                return servicesContainer(index, () {

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AppDialog(
                                        padding: EdgeInsets.zero,
                                        // margin: EdgeInsets.symmetric(horizontal: 16),
                                        child: scanDialog(index),
                                      );
                                    },
                                  );
                                });
                              },
                            )
                            : Container(child: Text("Not Found")),
                      ],
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        15.heightSizeBox,

                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AppDialog(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: SingleChildScrollView(
                                        child: TableCalendar(
                                          focusedDay: controller.focusedDay1,
                                          firstDay: DateTime.utc(2025, 3, 4),
                                          lastDay: DateTime.utc(2090, 3, 4),
                                          selectedDayPredicate: (day) {
                                            return isSameDay(
                                              day,
                                              controller.selectedDay1,
                                            );
                                          },
                                          calendarFormat:
                                              controller.calendarFormat,
                                          startingDayOfWeek:
                                              StartingDayOfWeek.monday,
                                          weekNumbersVisible: false,
                                          rangeStartDay:
                                              controller.rangeStartDate,
                                          rangeEndDay: controller.rangeEndDate,
                                          rangeSelectionMode:
                                              RangeSelectionMode.toggledOn,
                                          onRangeSelected:
                                              controller.onRangeSelected,
                                          calendarStyle: CalendarStyle(
                                            outsideDaysVisible: false,
                                          ),
                                          onDaySelected: (
                                            selectedDay,
                                            focusedDay,
                                          ) {
                                            controller.update();
                                          },
                                          onFormatChanged: (format) {
                                            if (controller.calendarFormat !=
                                                format) {
                                              controller.calendarFormat =
                                                  format;
                                              controller.update();
                                            }
                                          },
                                          onPageChanged: (focusedDay) {
                                            controller.focusedDay1 = focusedDay;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDateRange(
                                        controller.rangeStartDate,
                                        controller.rangeEndDate,
                                      ),
                                      style: w500_14p(color: AppColor.c2C2A2A),
                                    ),
                                    Icon(Icons.arrow_drop_down, size: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        ListView.separated(
                          padding: EdgeInsets.only(top: 20, bottom: 30),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          separatorBuilder: (BuildContext context, int index) {
                            return 15.heightSizeBox;
                          },

                          itemBuilder: (BuildContext context, int index) {
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

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return "Select Date Range";
    }
    final startDate =
        "${start.day.toString().padLeft(2, '0')} ${_getMonthName(start.month)} ${start.year}";
    final endDate =
        "${end.day.toString().padLeft(2, '0')} ${_getMonthName(end.month)} ${end.year}";
    return "$startDate – $endDate";
  }

  String _getMonthName(int month) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return monthNames[month - 1];
  }

  Widget servicesContainer(int index, VoidCallback onTap) {
    var customerData = controller.todayWashSummaryModel.value?.data?.washes;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            ProfileImageView(
              radius: 25,
              imagePath: customerData![index].profilePicUrl,
              radiusStack: 6,
              isVisibleStack: customerData[index].isPremium,
            ),
            15.widthSizeBox,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    customerData[index].customerName ?? "".tr,
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
                      if (customerData[index] == true) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 5),
                          child: DotedVerticalLine(height: 8.1),
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
                    ],
                  ),
                  7.heightSizeBox,
                ],
              ),
            ),
            customerData[index].rating == 0
                ? SizedBox()
                : Container(
                  width: 30,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ImageView(
                        path: Assets.iconsIcStar,
                        height: 14,
                        width: 14,
                      ),

                      Text(
                        "${customerData[index].rating ?? "".tr}",
                        style: w400_10a(color: AppColor.c455A64),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget todayWashes(
    String? totalWashTest,
    String? remainingWashTest,
    String? completedWashTest,
  ) {
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
                      totalWashTest ?? ''.tr,
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
                          Text(
                            completedWashTest ?? "".tr,
                            style: w500_24a(color: AppColor.white),
                          ),
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
                          Text(
                            remainingWashTest ?? "".tr,
                            style: w500_24a(color: AppColor.white),
                          ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
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

  Widget scanDialog(int index) {


    return Obx(

      (){return Column(
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
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                controller
                                    .todayWashSummaryModel
                                    .value
                                    ?.data
                                    ?.washes?[index]
                                    .profilePicUrl ??
                                '',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            placeholder:
                                (context, url) => Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Image.asset(
                                  Assets.imagesDemoProfile,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                          ),
                        ),
                      ),
                    ),
                    controller
                                .todayWashSummaryModel
                                .value
                                ?.data
                                ?.washes?[index]
                                .isPremium ==
                            true
                        ? Container(
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
                        )
                        : SizedBox(),
                  ],
                ),
                11.heightSizeBox,

                Text(
                  controller
                          .todayWashSummaryModel
                          .value
                          ?.data
                          ?.washes?[index]
                          .customerName ??
                      "",
                  style: w700_16a(color: AppColor.c2C2A2A),
                  textAlign: TextAlign.center,
                ),

                15.heightSizeBox,
                subscriptionRowWidget(
                  title: 'Pack Name ',
                  packName:
                  dashboardController
                          .getCustomerData
                          .value
                          ?.data
                          ?.subscriptionDetails
                          ?.subscriptionName ??
                      '',
                ),
                10.heightSizeBox,
                DotedHorizontalLine(),
                10.heightSizeBox,
                subscriptionRowWidget(
                  title: 'Expiry date ',
                  packName: formatDate(
                    dashboardController
                        .getCustomerData
                        .value
                        ?.data
                        ?.subscriptionDetails
                        ?.endDate,
                  ),
                ),
                10.heightSizeBox,
                DotedHorizontalLine(),
                10.heightSizeBox,
                subscriptionRowWidget(
                  title: 'Car Number',
                  packName:
                  dashboardController
                          .getCustomerData
                          .value
                          ?.data
                          ?.customerDetails
                          ?.carNumber ??
                      '',
                ),
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
      );}
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
