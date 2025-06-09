import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../../../network_manager/utils/api_response.dart';
import '../model/get_customer_data_model.dart';
import '../model/get_worker_model.dart';

class DashboardController extends GetxController {
  RxBool loading = false.obs;
  Rxn<ApiResponse> apiResponse = Rxn<ApiResponse>();

  final TextEditingController commentController = TextEditingController();
  Rxn<GetWorkerModel> getWorkerModel = Rxn();

  final String? userId = LocalStorage().getUserId();
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();

    if (userId != null) {
      final int? parsedId = int.tryParse(userId!);
      if (parsedId != null && parsedId > 0) {
        getWorkerDataById(parsedId);
      } else {
        print("Invalid or unparsable user ID: $userId");
      }
    } else {
      print("User ID not found in local storage");
    }
  }

  Future<GetWorkerModel?> getWorkerDataById(int id) async {
    try {
      getWorkerModel.value = await Repository().getWorkerData(id);

      getWorkerModel.value;
      update();
    } catch (error) {
      print("Error fetching customer data: $error");
      return null;
    }
    return null;
  }



}
