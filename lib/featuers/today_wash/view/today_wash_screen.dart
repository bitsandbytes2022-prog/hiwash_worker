import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/featuers/dashboard/controller/dashboard_controller.dart';
import 'package:hiwash_worker/featuers/dashboard/model/get_customer_data_model.dart';
import 'package:hiwash_worker/featuers/today_wash/controller/today_wash_controller.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';
import 'package:hiwash_worker/featuers/today_wash/model/wash_log_model.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/widgets/components/doted_vertical_line.dart';
import 'package:hiwash_worker/widgets/components/hi_wash_button.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../generated/assets.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/app_dialog.dart';
import '../../../widgets/components/data_formet.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/is_select_button.dart';
import '../../../widgets/components/profile_image_container.dart';
import '../../qr_scanner/controller/qr_controller.dart';

class TodayWashScreen extends StatelessWidget {
  TodayWashScreen({super.key});

  final TodayWashController controller = Get.put(TodayWashController());
  DashboardController dashboardController = Get.find();
  final QrController qrController =
      Get.isRegistered<QrController>() ? Get.find() : Get.put(QrController());

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
                        Obx(() {
                          final todayWashListData =
                              controller
                                  .todayWashSummaryModel
                                  .value
                                  ?.data
                                  ?.summary;

                          return GestureDetector(
                            child: todayWashes(
                              todayWashListData?.totalWashes.toString(),
                              todayWashListData?.remaining.toString(),
                              todayWashListData?.completed.toString(),
                            ),
                          );
                        }),
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
                                  (context, i) => SizedBox(height: 15),
                              shrinkWrap: true,
                              itemCount:
                                  controller
                                      .todayWashSummaryModel
                                      .value!
                                      .data!
                                      .washes!
                                      .length,
                              itemBuilder: (context, i) {
                                var washes = controller.todayWashSummaryModel.value?.data?.washes ?? [];

                                washes.sort((a, b) {
                                  DateTime dateA = DateTime.parse(a.redeemedAt ?? "");
                                  DateTime dateB = DateTime.parse(b.redeemedAt ?? "");
                                  return dateB.compareTo(dateA);
                                });

                                return servicesContainer(i, () async {
                                  final washes =
                                      controller
                                          .todayWashSummaryModel
                                          ?.value
                                          ?.data
                                          ?.washes;

                                  if (washes != null && i < washes.length) {
                                    final customerId = washes[i].customerId;
                                    if (customerId != null) {
                                      await controller.getCustomerDataById(
                                        customerId,
                                      );
                                    }
                                  }

                                  final washItem =
                                      controller
                                          .todayWashSummaryModel
                                          .value!
                                          .data!
                                          .washes![i];

                                  showDialog(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    builder: (context) {
                                      return AppDialog(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        child: successDialog(
                                          washDetail: washItem,
                                          offerTitle:
                                              qrController
                                                  .getOffersByIdModel
                                                  .value
                                                  ?.offersByIList
                                                  ?.first
                                                  .title ??
                                              "",
                                          getCustomer:
                                              controller
                                                  .getCustomerData
                                                  .value
                                                  ?.data,
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                            )
                            : SizedBox(),
                      ],
                    ),
                  )
                  : Obx(() {
                    final groupedLogs = groupLogsByDate(
                      controller.washLogModel.value?.data ?? [],
                    );

                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              15.heightSizeBox,
                              GestureDetector(
                                onTap: () {
                                  controller.isCalenderSelected.value =
                                      !controller.isCalenderSelected.value;
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
                                          controller.rangeStartDate.value,
                                          controller.rangeEndDate.value,
                                        ),
                                        style: w500_14p(
                                          color: AppColor.c2C2A2A,
                                        ),
                                      ),
                                      ImageView(
                                        path: Assets.iconsDownArrow,
                                        height: 6,
                                        width: 8,
                                        color: AppColor.c2C2A2A,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  15.heightSizeBox,
                                  ListView.separated(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      bottom: 30,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: groupedLogs.length,
                                    separatorBuilder:
                                        (_, __) => 15.heightSizeBox,
                                    itemBuilder: (context, index) {
                                      final dateKey = groupedLogs.keys
                                          .elementAt(index);
                                      final logs = groupedLogs[dateKey]!;

                                      return Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 14),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColor.c142293
                                                      .withOpacity(0.15),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children:
                                                  logs
                                                      .map(
                                                        (log) => Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 8,
                                                              ),
                                                          child: washLogRow(
                                                            log: log,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: AppColor.c142293
                                                    .withOpacity(0.10),
                                              ),
                                            ),
                                            child: Text(
                                              formatDate(
                                                logs[0].redeemedAt ?? "",
                                              ),
                                              style: w500_10p(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (controller.isCalenderSelected.value)
                            Container(
                              margin: EdgeInsets.only(top: 60),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
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
                                calendarFormat: controller.calendarFormat,
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                weekNumbersVisible: false,
                                rangeStartDay: controller.rangeStartDate.value,
                                rangeEndDay: controller.rangeEndDate.value,
                                rangeSelectionMode:
                                    RangeSelectionMode.toggledOn,
                                onRangeSelected: controller.onRangeSelected,
                                calendarStyle: CalendarStyle(
                                  outsideDaysVisible: false,
                                ),
                                onDaySelected: (selectedDay, focusedDay) {
                                  controller.update();
                                },
                                onFormatChanged: (format) {
                                  if (controller.calendarFormat != format) {
                                    controller.calendarFormat = format;
                                    controller.update();
                                  }
                                },
                                onPageChanged: (focusedDay) {
                                  controller.focusedDay1 = focusedDay;
                                  //  controller.isCalenderSelected.value = false;
                                  //  controller.update();
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
        ),
      ],
    );
  }

  Widget servicesContainer(int index, VoidCallback onTap) {
    var customerData = controller.todayWashSummaryModel.value?.data?.washes;
    bool isCompleted = customerData![index].rating != 0;

    return GestureDetector(
      onTap: isCompleted ? null : onTap,
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
                            formatDate(customerData[index].redeemedAt ?? ""),
                            style: w400_12a(color: AppColor.c455A64),
                          ),
                        ],
                      ),
                      if ((customerData[index].offerTitle ?? '')
                          .isNotEmpty) ...[
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
                              customerData[index].offerTitle ?? '',
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

  Widget successDialog({
    required Washes washDetail,
    required String offerTitle,
    Data? getCustomer,
  }) {
    return WillPopScope(
      onWillPop: () async {
        controller.userRating = 0;
        controller.commentController.clear();
        controller.commentText.value = "";
        controller.update();
        return true;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.red,
                  padding: const EdgeInsets.only(bottom: 1),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: Get.height * 0.50,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),

                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              30.heightSizeBox,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ImageView(
                                  path: Assets.iconsIcCongrat,

                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              21.heightSizeBox,
                              Text(
                                StringConstant.kWashComplete.tr,
                                style: w700_22a(color: AppColor.c2C2A2A),
                              ),
                              Text(
                                StringConstant.kShareYourFeedback.tr,
                                textAlign: TextAlign.center,
                                style: w400_16p(),
                              ),
                              9.heightSizeBox,
                              GetBuilder<TodayWashController>(
                                builder: (controller) {
                                  return RatingStars(
                                    value: controller.userRating.toDouble(),
                                    onValueChanged: (v) {
                                      controller.userRating = v.toInt();
                                      controller.update();
                                    },
                                    starBuilder:
                                        (index, color) => Icon(
                                          Icons.star,
                                          color: color,
                                          size: 28,
                                        ),
                                    starCount: 5,
                                    starSize: 28,
                                    valueLabelVisibility: false,
                                    starColor: AppColor.cFFC200,
                                    starOffColor: Colors.grey,

                                    animationDuration: Duration(
                                      milliseconds: 200,
                                    ),
                                    starSpacing: 2,
                                  );
                                },
                              ),
                              15.heightSizeBox,
                              TextFormField(
                                cursorColor: AppColor.blue,
                                controller: controller.commentController,
                                maxLines: 3,
                                // fillColor: AppColor.white,
                                style: w400_14p(
                                  color: AppColor.c2C2A2A.withOpacity(0.9),
                                ),
                                decoration: InputDecoration(
                                  fillColor: AppColor.white,
                                  hintText:
                                      StringConstant.kEnterYourCommentHere.tr,
                                  filled: true,
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
                                      color: AppColor.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.c5C6B72.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.c5C6B72.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.c5C6B72.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.c5C6B72.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.c5C6B72.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              30.heightSizeBox,
                              Obx(() {
                                final comment = controller.commentText.value;
                                final rating = controller.userRating;
                                final isButtonEnabled =
                                    comment.isNotEmpty && rating > 0;

                                return HiWashButton(
                                  isLoading: controller.isLoading.value,
                                  width: 100,
                                  text: StringConstant.kSubmit.tr,
                                  onTap:
                                      isButtonEnabled
                                          ? () {
                                            controller
                                                .getRating(
                                                  rating.toString(),
                                                  washDetail.id.toString(),
                                                  comment,
                                                )
                                                .then((value) {
                                                  if (value != null) {
                                                    Get.back();
                                                    controller
                                                        .getTodayWashSummary();
                                                    controller.userRating = 0;
                                                    controller.commentController
                                                        .clear();
                                                  }
                                                });
                                          }
                                          : null,
                                );
                              }),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 1),

                        padding: EdgeInsets.only(bottom: 2),
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
                              padding: EdgeInsets.only(
                                top: 23,
                                left: 19,
                                bottom: 23,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ProfileImageView(
                                    radius: 20,
                                    radiusStack: 4,

                                    isVisibleStack:
                                        (controller
                                                    .getCustomerData
                                                    .value
                                                    ?.data
                                                    ?.subscriptionDetails!
                                                    .isPremium ??
                                                false)
                                            ? true
                                            : false,
                                    imagePath: washDetail.profilePicUrl,
                                  ),
                                  9.widthSizeBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                                .getCustomerData
                                                .value
                                                ?.data
                                                ?.customerDetails
                                                ?.fullName ??
                                            '',
                                        style: w600_14a(
                                          color: AppColor.c2C2A2A,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IsSelectButton(),
                                          5.widthSizeBox,
                                          Text(
                                            formatDate(
                                              controller
                                                      .getCustomerData
                                                      .value
                                                      ?.data
                                                      ?.subscriptionDetails
                                                      ?.startDate ??
                                                  '',
                                            ),
                                            style: w400_12a(
                                              color: AppColor.c455A64,
                                            ),
                                          ),
                                        ],
                                      ),

                                      if ((offerTitle ?? '').isNotEmpty) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: DotedVerticalLine(height: 15),
                                        ),

                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IsSelectButton(),
                                            5.widthSizeBox,
                                            Text(
                                              offerTitle ?? '',
                                              style: w400_12a(
                                                color: AppColor.c455A64,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // controller
          //             .getCustomerData
          //             .value
          //             ?.data
          //             ?.subscriptionDetails
          //             ?.subscriptionId ==
          //         1
          //     ? Positioned(
          //       bottom: 0,
          //       left: 20,
          //       right: 20,
          //       child: Container(
          //         padding: EdgeInsets.only(top: 20),
          //         child: Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             Image.asset(Assets.imagesDialogBottom),
          //             RichText(
          //               text: TextSpan(
          //                 text: "${StringConstant.kRemainingWash.tr}: ",
          //                 style: w500_14p(color: AppColor.c2C2A2A),
          //                 children: [
          //                   TextSpan(
          //                     text:
          //                         controller
          //                             .getCustomerData
          //                             .value
          //                             ?.data
          //                             ?.subscriptionDetails
          //                             ?.remainingWashes
          //                             .toString(),
          //                     style: w400_16p(color: AppColor.cC31848),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     )
          //     : SizedBox(),

          Positioned(
            top: 3,
            right: 8,
            child: GestureDetector(
              onTap: () {
                controller.userRating = 0;
                controller.commentController.clear();
                controller.commentText.value = "";
                controller.update();
                Get.back();
              },
              child: Container(
                height: 40,
                width: 40,
                child: ImageView(
                  path: Assets.iconsIcClose,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<WashLogData>> groupLogsByDate(List<WashLogData> logs) {
    Map<String, List<WashLogData>> grouped = {};

    for (var log in logs) {
      if (log.redeemedAt != null) {
        DateTime parsedDate = DateTime.parse(log.redeemedAt!);

        final dateKey = DateFormat('yyyy-MM-dd').format(parsedDate);

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(log);
      }
    }

    var sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    Map<String, List<WashLogData>> sortedGroupedLogs = {};
    for (var key in sortedKeys) {
      sortedGroupedLogs[key] = grouped[key]!;
    }

    return sortedGroupedLogs;
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      final defaultStart = DateTime.now().subtract(Duration(days: 10));
      final defaultEnd = DateTime.now();

      final startDate =
          "${defaultStart.day.toString().padLeft(2, '0')} ${_getMonthName(defaultStart.month)} ${defaultStart.year}";
      final endDate =
          "${defaultEnd.day.toString().padLeft(2, '0')} ${_getMonthName(defaultEnd.month)} ${defaultEnd.year}";
      return "$startDate – $endDate";
    }

    final startDate =
        "${start.day.toString().padLeft(2, '0')} ${_getMonthName(start.month)} ${start.year}";
    final endDate =
        "${end.day.toString().padLeft(2, '0')} ${_getMonthName(end.month)} ${end.year}";
    return "$startDate – $endDate";
  }

  String _getMonthName(int month) {
    final months = [
      StringConstant.kJan.tr,
      StringConstant.kFev.tr,
      StringConstant.kMar.tr,
      StringConstant.kApr.tr,
      StringConstant.kMay.tr,
      StringConstant.kJun.tr,
      StringConstant.kJul.tr,
      StringConstant.kAug.tr,
      StringConstant.kSep.tr,
      StringConstant.kAct.tr,
      StringConstant.kNov.tr,
      StringConstant.kDec.tr,
    ];
    return months[month - 1];
  }

  Widget washLogRow({required WashLogData log}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        15.widthSizeBox,
        ProfileImageView(
          radius: 20,
          radiusStack: 4,

          imagePath: log.profilePicUrl,
          isVisibleStack: log.isPremium,
        ),

        11.widthSizeBox,
        Expanded(
          child: Text(
            log.customerName ?? "",
            style: w600_12a(color: AppColor.c2C2A2A),
          ),
        ),
        Text(
          formatDate(log.redeemedAt),
          style: w400_12a(color: AppColor.c2C2A2A),
        ),
        20.widthSizeBox,
        log.rating == 0
            ? SizedBox()
            : Container(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  Text(
                    log.rating.toString(),
                    style: w400_10a(color: AppColor.c455A64),
                  ),
                  2.widthSizeBox,
                  ImageView(path: Assets.iconsIcStar, height: 10, width: 10),
                ],
              ),
            ),
      ],
    );
  }

  Widget todayWashes(
    String? totalWashText,
    String? remainingWashText,
    String? completedWashText,
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
                      completedWashText ?? ''.tr,
                      style: w700_27a(
                        color: AppColor.white,
                      ).copyWith(fontSize: 47),
                    ),
                    3.widthSizeBox,
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        completedWashText == null ||
                                int.parse(completedWashText) == 0
                            ? "Completed Wash"
                            : "Completed Washes",
                        /* StringConstant.kTodayWashes.tr*/
                        style: w500_16p(color: AppColor.white.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /*  Container(
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
                            completedWashText ?? "".tr,
                            style: w500_24a(color: AppColor.white),
                          ),
                          Text(
                            StringConstant.kComplete.tr,
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
                            remainingWashText ?? "".tr,
                            style: w500_24a(color: AppColor.white),
                          ),
                          Text(
                            StringConstant.kRemaining.tr,
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
          ),*/
        ],
      ),
    );
  }

  Widget rowDivider() {
    return Column(
      children: [10.heightSizeBox, DotedHorizontalLine(), 10.heightSizeBox],
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


