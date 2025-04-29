import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/widgets/components/doted_vertical_line.dart';

import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../generated/assets.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_anybody.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/app_dialog.dart';
import '../../../widgets/components/custom_swipe_button.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/is_select_button.dart';
import '../../../widgets/components/profile_image_container.dart';
import '../../../widgets/components/star_rating.dart';
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
                      /*    onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AppDialog(
                                  padding: EdgeInsets.zero,
                                  // margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: scanDialog(),
                                );
                              },
                            );
                          },*/
                          child: todayWashes(),
                        ),
                        21.heightSizeBox,

                        ListView.separated(
                          padding: EdgeInsets.only(top: 0, bottom: 40),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => 15.heightSizeBox,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return servicesContainer(index);
                          },
                        ),
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

  Widget servicesContainer(int index) {
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
          ProfileImageView(radius: 25, radiusStack: 6,isVisibleStack:index%2==0? true:false,),
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
                      "10",
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
                          Text("4", style: w500_24a(color: AppColor.white)),
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
                          Text("6", style: w500_24a(color: AppColor.white)),
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


}
