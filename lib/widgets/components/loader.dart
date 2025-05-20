
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
void showLoader() {
  Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false, );
}
hideLoader() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}
