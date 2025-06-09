import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/widgets/components/app_snack_bar.dart';
import '../../../network_manager/repository.dart';
import '../model/terms_and_conditions_response_model.dart';
import 'package:image_picker/image_picker.dart';

class DrawerProfileController extends GetxController {
  RxBool isLoading = false.obs;
  var imageFile = Rx<File?>(null);
  var isSwitchOn = false.obs;
  RxBool isUploadingProfileImage = false.obs;
  Rxn<TermsAndConditionsResponseModel> termsAndConditionsResponseModel = Rxn();
  var currentDrawerSection = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future<void> imagePicker({required ImageSource source}) async {
    var pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,

      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    } else {
      print("No file selected");
    }
  }

  void toggleDrawer(String section) {
    if (currentDrawerSection.value == section) {
      currentDrawerSection.value = '';
    } else {
      currentDrawerSection.value = section;
    }
  }

  Future<dio.FormData> getFormDataForUpload() async {
    final fileName = imageFile.value?.path.split('/').last;
    var file = await dio.MultipartFile.fromFile(
      imageFile.value!.path,
      filename: fileName,
    );
    return dio.FormData.fromMap({"file": file});
  }

  Future<bool> uploadProfileImage() async {
    isUploadingProfileImage.value = true;
    try {
      final formData = await getFormDataForUpload();
      final response = await Repository().uploadProfilePicture(formData);

      if (response != null && response['success'] == true) {
        appSnackBar(
          title: StringConstant.kSuccess.tr,
          backgroundColor: Colors.green,
          message:
              response['message'] ??
              StringConstant.kProfileUpdatedSuccessfully.tr,
        );
        return true;
      } else {
        imageFile.value = null;
        return false;
      }
    } catch (e) {
      imageFile.value = null;
      return false;
    } finally {
      isUploadingProfileImage.value = false;
    }
  }

  Future<TermsAndConditionsResponseModel?> getTermsAndConditions() async {
    var entityType = 1;
    try {
      termsAndConditionsResponseModel.value = await Repository()
          .getTermsAndConditions(entityType);
      return termsAndConditionsResponseModel.value;
    } catch (error) {
      print("Error fetching Terms And Condition: $error");
      return null;
    }
  }

  Future<dynamic> uploadProfile(
    String fullName,
    String email,
    String address,
  ) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> requestBody = {
        "fullName": fullName,
        "email": email,
        "address": address,
      };

      final response = await Repository().uploadProfile(requestBody);
      if (response != null && response['success'] == true) {
        appSnackBar(
          title: StringConstant.kSuccess.tr,
          backgroundColor: Colors.green,
          message:
              response['message'] ??
              StringConstant.kProfileUpdatedSuccessfully.tr,
        );
      }

      return response;
    } catch (e) {
      print("Update profile error: $e");

      appSnackBar(message: StringConstant.kSomethingWentWrong.tr);
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
