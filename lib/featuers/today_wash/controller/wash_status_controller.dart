import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hiwash_worker/featuers/auth/auth_controller/auth_controller.dart';
import 'package:hiwash_worker/featuers/profile/model/terms_and_conditions_response_model.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';
import 'package:hiwash_worker/widgets/components/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../network_manager/repository.dart';
import '../../../network_manager/utils/api_response.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/model/get_customer_data_model.dart';
import 'package:dio/dio.dart' as dio;

import '../../qr_scanner/controller/qr_controller.dart';
import '../model/wash_log_model.dart';

class WashStatusController extends GetxController {




  Rx<XFile?> pickedImage = Rx<XFile?>(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        pickedImage.value = image;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  RxBool isWashSelected = true.obs;
  RxBool isCalenderSelected = false.obs;

  Rx<DateTime?> rangeStartDate1 = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate1 = Rx<DateTime?>(null);
  Rxn<TodayWashSummaryModel> todayWashSummaryModel = Rxn();
  Rxn<WashLogModel> washLogModel = Rxn();
  //Rxn<WashLogModel> washLogModel = Rxn();


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

  Rx<DateTime?> rangeStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate = Rx<DateTime?>(null);

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

  Future<void> onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) async {
    rangeStartDate.value = start;
    rangeEndDate.value = end;
    focusedDay1 = focusedDay;
    selectedDay1 = null;

    print("Start--->${rangeStartDate.value}");
    print("End--->${rangeEndDate.value}");

    if (start != null && end != null) {
      await washLog(start.toIso8601String(), end.toIso8601String());
      update();
    }
  }


  String formatDateRange(DateTime? start, DateTime? end) {
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

  Future<TodayWashSummaryModel?> getTodayWashSummary() async {
    try {
      //showLoader();
      todayWashSummaryModel.value = await Repository().todayWashSummaryRepo();
      // hideLoader();

      return todayWashSummaryModel.value;
    } catch (error) {
      print("Error fetching Terms And Condition: $error");
      return null;
    }
  }

  Rxn<GetCustomerData> getCustomerData = Rxn();

  Future<GetCustomerData?> getCustomerDataById(int id) async {
    try {
      showLoader();
      getCustomerData.value = await Repository().getCustomerData(id);

      if (getCustomerData.value?.data != null) {
        int? customerId = getCustomerData.value?.data!.customerDetails?.id;
        print("Customer ID: $customerId");
      }

      hideLoader();
      return getCustomerData.value;
    } catch (error) {
      print("Error fetching customer data: $error");
      return null;
    }
  }
  Future<void> completeWash(String? washId, {bool requireImage = false}) async {
    try {
      dio.FormData formData;

      if (requireImage) {
        if (pickedImage.value == null) {
          Get.snackbar("Error", "Please capture an image.");
          return;
        }

        final file = File(pickedImage.value!.path);
        final fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          Get.snackbar("Error", "File size exceeds 2MB.");
          return;
        }

        formData = await dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            pickedImage.value!.path,
            filename: pickedImage.value!.path.split('/').last,
          ),
          "WashId": washId,
        });
      } else {
        formData = dio.FormData.fromMap({
          "WashId": washId,
        });
      }

      final response = await Repository().completeWashRepo(formData);
      print("Upload success");
      return response;

    } catch (e) {
      print("Upload error: $e");
      rethrow;
    }
  }

/*  Future<void> completeWash(String? washId) async {
    try {

      final file = File(pickedImage.value!.path);
      final fileSize = await file.length();

      if (fileSize > 2 * 1024 * 1024) {
        Get.snackbar("Error", "File size exceeds 2MB.");
        return;
      }

      dio.FormData formData = await dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          pickedImage.value!.path,
          filename: pickedImage.value!.path.split('/').last,
        ),
        "WashId": washId,
      });
      final response = await Repository().completeWashRepo(formData);
      print("m------>}");
      return response;
    } catch (e) {
      print("Upload error: $e");
      rethrow;
    }}*/

/*  Future<dynamic> completeWash(String?washId,) async {
    try {
      dio.FormData formData = await dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          pickedImage.value!.path,
          filename: pickedImage.value!.path.split('/').last,
        ),
        "WashId": washId,
      });
      final response = await Repository().completeWashRepo(formData);
      print("m------>}");
      return response;
    } catch (e) {
      print("Upload error: $e");
      rethrow;
    }
  }*/

  Future<WashLogModel?> washLog(String startingDate, String endingDate) async {
    try {
      showLoader();
      washLogModel.value = await Repository().washLogRepo({
        "startDate": startingDate,
        "endDate": endingDate,
      });
      hideLoader();
      return washLogModel.value;
    } catch (e) {
      hideLoader();
      print("Wash log error: $e");
      rethrow;
    }
  }

  int userRating = 0;
  final TextEditingController commentController = TextEditingController();

  Rxn<ApiResponse> apiResponse = Rxn<ApiResponse>();
  Future<ApiResponse?> getRating(
      String rating,
      String washId,
      String comment,
      ) async {
    Map params = {"rating": rating, "washId": washId, "comment": comment};
    try {
      print("Rating body--->: $params");
      //  loading.value = true;
      apiResponse.value = await Repository().rating(params);
      return apiResponse.value;
    } catch (e) {
      print("Error in controller: $e");
      return null;
    } finally {
      // loading.value = false;
    }
  }
}
