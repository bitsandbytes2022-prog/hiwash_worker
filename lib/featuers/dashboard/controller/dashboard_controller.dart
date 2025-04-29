import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../../../network_manager/utils/api_response.dart';
import '../model/get_worker_model.dart';

class DashboardController extends GetxController {
  RxBool loading = false.obs;
  Rxn<ApiResponse> apiResponse = Rxn<ApiResponse>();
  int userRating = 0;
  final TextEditingController commentController = TextEditingController();
  Rxn<GetWorkerModel> getWorkerModel = Rxn();
  final String? userId = LocalStorage().getUserId();

  @override
  void onInit() {
    super.onInit();

    if (userId != null) {
      final int? parsedId = int.tryParse(userId!);
      if (parsedId != null && parsedId > 0) {
        getCustomerDataById(parsedId);
      } else {
        print("Invalid or unparsable user ID: $userId");
      }
    } else {
      print("User ID not found in local storage");
    }
  }

  Future<GetWorkerModel?> getCustomerDataById(int id) async {
    // loading = true;\
    try {
      getWorkerModel.value = await Repository().getWorkerData(id);
      // loading = false;

      getWorkerModel.value;
      update();
    } catch (error) {
      // loading = false;
      print("Error fetching customer data: $error");
      return null;
    }
    return null;
  }

  var isLoading = false.obs;

  Future<dynamic> sendOtp(String phoneNumber) async {
    Map<String, dynamic> requestBody = {"customerId": phoneNumber};
    try {
      isLoading.value = true;
      var response = await Repository().validateWashQrRepo(requestBody);
      print("Value received in controller sendOtp: $response");
      return response;
    } catch (e) {
      print("Error in controller while sending OTP: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /*
  Future<ApiResponse?> getRating(
    String rating,
    String workerId,
    String locationId,
    String comment,
  ) async {
    Map params = {
      "rating": rating,
      "workerId": workerId,
      "locationId": locationId,
      "comment": comment,
    };
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

  }*/
}
