import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class WashStatusController extends GetxController {
  RxBool isWashSelected = true.obs;

  Rx<DateTime?> rangeStartDate1 = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate1 = Rx<DateTime?>(null);

  // Toggle wash selection
  void toggleWashSelection() {
    isWashSelected.value = !isWashSelected.value;
  }

  // Update the selected date range
  void updateDateRange(DateTime? startDate, DateTime? endDate) {
    rangeStartDate1.value = startDate;
    rangeEndDate1.value = endDate;
  }

  CalendarFormat calendarFormat = CalendarFormat.month;

  DateTime focusedDay1 = DateTime.now();
  DateTime? selectedDay1;

  DateTime? rangeStartDate;

  DateTime? rangeEndDate;

  @override
  void onInit() {
    selectedDay1 = focusedDay1;
    update();
  }

  void onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDay1!, selectedDay)) {
     selectedDay1 = selectedDay;
  focusedDay1 = focusedDay;
      update();
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    rangeStartDate = start;
    rangeEndDate = end;
   focusedDay1 = focusedDay;
    selectedDay1 = null;
    update();
    print("Start--->${rangeStartDate}");
    print("End--->${rangeEndDate}");
  }
}
