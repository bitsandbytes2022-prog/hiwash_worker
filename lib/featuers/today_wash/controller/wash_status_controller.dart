import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';
import 'package:hiwash_worker/widgets/components/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../network_manager/repository.dart';
import '../../../network_manager/utils/api_response.dart';
import '../../dashboard/model/get_customer_data_model.dart';
import 'package:dio/dio.dart' as dio;

import '../model/wash_log_model.dart';

class WashStatusController extends GetxController {




  Rx<XFile?> pickedImage = Rx<XFile?>(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 20);
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

  void toggleWashSelection() async {
    isWashSelected.value = !isWashSelected.value;

  }

  CalendarFormat calendarFormat = CalendarFormat.month;

  DateTime focusedDay1 = DateTime.now();
  DateTime? selectedDay1;

  Rx<DateTime?> rangeStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate = Rx<DateTime?>(null);



  DateTime get defaultStartDate => DateTime.now().subtract(Duration(days: 10));
  DateTime get defaultEndDate => DateTime.now();



  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTodayWashSummary();
      washLog(defaultStartDate.toIso8601String(), defaultEndDate.toIso8601String());
    });
  }
  Future<void> onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) async {
    rangeStartDate.value = start;
    rangeEndDate.value = end;
    focusedDay1 = focusedDay;
    selectedDay1 = null;

    if (start != null && end != null) {
      await washLog(start.toIso8601String(), end.toIso8601String());
    }

    update();
  }

  Future<WashLogModel?> washLog([String? startingDate, String? endingDate]) async {
    try {
      //showLoader();

      if (startingDate != null && endingDate != null) {
        washLogModel.value = await Repository().washLogRepo({
          "startDate": startingDate,
          "endDate": endingDate,
        });
      } else {
        washLogModel.value = await Repository().washLogRepo({});
      }

     // hideLoader();
      return washLogModel.value;
    } catch (e) {
      hideLoader();
      print("Wash log error: $e");
      rethrow;
    }
  }




  /// only date
/*
  Future<void> onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) async {
    rangeStartDate.value = start;
    rangeEndDate.value = end;
    focusedDay1 = focusedDay;
    selectedDay1 = null;

    print("Start ---> $start");
    print("End   ---> $end");

    if (start != null && end != null) {
      await washLog(start.toIso8601String(), end.toIso8601String());
    } else {
      await washLog();
    }

    update();
  }

  Future<WashLogModel?> washLog([String? startingDate, String? endingDate]) async {
    try {
      showLoader();

      if (startingDate != null && endingDate != null) {
        washLogModel.value = await Repository().washLogRepo({
          "startDate": startingDate,
          "endDate": endingDate,
        });
      } else {
        washLogModel.value = await Repository().washLogRepo({});
      }

      hideLoader();
      return washLogModel.value;
    } catch (e) {
      hideLoader();
      print("Wash log error: $e");
      rethrow;
    }
  }

*/



  Future<TodayWashSummaryModel?> getTodayWashSummary() async {
    try {

      todayWashSummaryModel.value = await Repository().todayWashSummaryRepo();
      return todayWashSummaryModel.value;
    } catch (error) {
      print("Error fetching Terms And Condition: $error");
      return null;
    }
  }

  Rxn<GetCustomerData> getCustomerData = Rxn();

  Future<GetCustomerData?> getCustomerDataById(int id) async {
    try {
     // showLoader();
      getCustomerData.value = await Repository().getCustomerData(id);

      if (getCustomerData.value?.data != null) {
        int? customerId = getCustomerData.value?.data!.customerDetails?.id;
        print("Customer ID: $customerId");
      }

     // hideLoader();
      return getCustomerData.value;
    } catch (error) {
      print("Error fetching customer data: $error");
      return null;
    }
  }
  Future<void> completeWash(String? washId, {bool? requireImage}) async {
    try {
      dio.FormData formData;

      if (requireImage?? false) {
        if (pickedImage.value == null) {
          Get.snackbar("Error", "Please capture an image.");
          return;
        }

        final file = File(pickedImage.value!.path);
        final fileSize = await file.length();

        // if (fileSize > 2 * 1024 * 1024) {
        //   Get.snackbar("Error", "File size exceeds 2MB.");
        //   return;
        // }
var fileMult= await dio.MultipartFile.fromFile(
    pickedImage.value!.path,filename: pickedImage.value!.path.split('/').last,
    );
        formData = await dio.FormData.fromMap({
          "file":fileMult,

          "WashId": washId,
        });
      } else {
        formData = dio.FormData.fromMap({
          "WashId": washId,
        });
      }
showLoader();


      final response = await Repository().completeWashRepo(formData);
      hideLoader();
      print("Upload success");
      return response;

    } catch (e) {
      hideLoader();
      Get.snackbar("Error", "$e.");

      print("Upload error: $e");
      rethrow;
    }
  }


  /*Future<WashLogModel?> washLog(String startingDate, String endingDate) async {
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
  }*/


  final TextEditingController commentController = TextEditingController();
  int userRating = 0;
  Rxn<ApiResponse> apiResponse = Rxn<ApiResponse>();
  Future<ApiResponse?> getRating(
      String rating,
      String washId,
      String comment,
      ) async {
    Map params = {"rating": rating, "washId": washId, "comment": comment};
    try {
      print("Rating body--->: $params");

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
