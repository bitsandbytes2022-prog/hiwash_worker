import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/widgets/components/app_snack_bar.dart';
import 'package:hiwash_worker/widgets/components/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../network_manager/repository.dart';
import '../../../network_manager/utils/api_response.dart';
import '../../dashboard/model/get_customer_data_model.dart';
import 'package:dio/dio.dart' as dio;

import '../model/wash_log_model.dart';

class TodayWashController extends GetxController {
  Rx<XFile?> pickedImage = Rx<XFile?>(null);

  final ImagePicker _picker = ImagePicker();

  RxBool isWashSelected = true.obs;
  RxBool isCalenderSelected = false.obs;

  Rx<DateTime?> rangeStartDate1 = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate1 = Rx<DateTime?>(null);
  Rxn<TodayWashSummaryModel> todayWashSummaryModel = Rxn();
  Rxn<WashLogModel> washLogModel = Rxn();
  Rxn<GetCustomerData> getCustomerData = Rxn();
  RxString commentText = ''.obs;

  final TextEditingController commentController = TextEditingController();
  int userRating = 0;
  Rxn<ApiResponse> apiResponse = Rxn<ApiResponse>();

  CalendarFormat calendarFormat = CalendarFormat.month;

  DateTime focusedDay1 = DateTime.now();
  DateTime? selectedDay1;

  Rx<DateTime?> rangeStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEndDate = Rx<DateTime?>(null);

  DateTime get defaultStartDate => DateTime.now().subtract(Duration(days: 10));

  DateTime get defaultEndDate => DateTime.now();

  void toggleWashSelection() async {
    isWashSelected.value = !isWashSelected.value;
  }

  @override
  void onInit() {
    commentController.addListener(() {
      commentText.value = commentController.text.trim();
    });
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTodayWashSummary();
      washLog(
        defaultStartDate.toIso8601String(),
        defaultEndDate.toIso8601String(),
      );
    });
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      if (image != null) {
        pickedImage.value = image;
      }
    } catch (e) {
      print("Error picking image from camera: $e");
      // Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }


  Future<void> onRangeSelected(
    DateTime? start,
    DateTime? end,
    DateTime focusedDay,
  ) async {
    rangeStartDate.value = start;
    rangeEndDate.value = end;
    focusedDay1 = focusedDay;
    selectedDay1 = null;

    if (start != null && end != null) {
      await washLog(start.toIso8601String(), end.toIso8601String());
      isCalenderSelected.value = false;
    }

    update();
  }

  Future<WashLogModel?> washLog([
    String? startingDate,
    String? endingDate,
  ]) async {
    try {
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

  Future<TodayWashSummaryModel?> getTodayWashSummary() async {
    try {
      todayWashSummaryModel.value = await Repository().todayWashSummaryRepo();
      return todayWashSummaryModel.value;
    } catch (error) {
      print("Error fetching Today Wash: $error");
      return null;
    }
  }


  Future<GetCustomerData?> getCustomerDataById(int id) async {
    try {
      getCustomerData.value = await Repository().getCustomerData(id);

      if (getCustomerData.value?.data != null) {
        int? customerId = getCustomerData.value?.data!.customerDetails?.id;
        print("Customer ID: $customerId");
      }

      return getCustomerData.value;
    } catch (error) {
      print("Error fetching  sscustomer data: $error");
      return null;
    }
  }

  Future<void> completeWash(String? washId, {bool? requireImage}) async {
    try {
      isLoading.value=true;
      dio.FormData formData;
      if (requireImage ?? false) {
        if (pickedImage.value == null) {
          appSnackBar(message: StringConstant.kPleaseCaptureAnImage.tr);
          return;
        }

        final file = File(pickedImage.value!.path);
        final fileSize = await file.length();
        var fileMult = await dio.MultipartFile.fromFile(
          pickedImage.value!.path,
          filename: pickedImage.value!.path.split('/').last,
        );
        formData = await dio.FormData.fromMap({
          "file": fileMult,

          "WashId": washId,
        });
      } else {
        formData = dio.FormData.fromMap({"WashId": washId});
      }


      final response = await Repository().completeWashRepo(formData);

      print("Upload success${response.toString()}");
      return response;
    } catch (e) {
      appSnackBar(message: "${e}");

      rethrow;
    }finally{
      isLoading.value=false;
    }
  }


  RxBool isLoading = false.obs;

  Future<ApiResponse?> getRating(
      String rating,
      String washId,
      String comment,
      ) async {
    Map<String, String> params = {
      "rating": rating,
      "washId": washId,
      "comment": comment
    };

    try {
      isLoading.value = true;
      apiResponse.value = await Repository().rating(params);
      return apiResponse.value;
    } catch (e) {
      print("Error in controller: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

/*  Future<ApiResponse?> getRating(
    String rating,
    String washId,
    String comment,
  ) async {

    Map params = {"rating": rating, "washId": washId, "comment": comment};
    try {

      apiResponse.value = await Repository().rating(params);

      return apiResponse.value;

    } catch (e) {

      print("Error in controller: $e");
      return null;
    }
  }*/
}
