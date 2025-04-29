import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hiwash_worker/featuers/profile/model/terms_and_conditions_response_model.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../network_manager/repository.dart';

class WashStatusController extends GetxController {





  RxBool isWashSelected = true.obs;

  Rx<DateTime?> rangeStartDate1 = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate1 = Rx<DateTime?>(null);
  Rxn<TodayWashSummaryModel> todayWashSummaryModel = Rxn();


  void toggleWashSelection() {
    isWashSelected.value = !isWashSelected.value;
  }

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
    getTodayWashSummary();
    super.onInit();
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



  Future<TodayWashSummaryModel?> getTodayWashSummary() async {
    try {
      todayWashSummaryModel.value = await Repository()
          .todayWashSummaryRepo();
      return todayWashSummaryModel.value;
    } catch (error) {
      print("Error fetching Terms And Condition: $error");
      return null;
    }
  }

}
