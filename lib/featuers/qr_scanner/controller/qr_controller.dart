import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/featuers/today_wash/controller/wash_status_controller.dart';
import 'package:hiwash_worker/route/route_strings.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../../dashboard/model/get_customer_data_model.dart';
import '../model/get_offers_by_id_model.dart';

class QrController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  RxString scanUrl = ''.obs;
  RxString customerId = ''.obs;
  RxString offerIdForReward = ''.obs;
  RxString internetStatus = ''.obs;
  RxBool hasScanned = false.obs;

  late AnimationController animationController;
  late Animation<double> animation;
  final LocalStorage localStorage = LocalStorage();
  WashStatusController washStatusController =Get.find();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    checkInternetConnection();
  }

  @override
  void onReady() {
    super.onReady();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 150).animate(animationController);

    qrController?.resumeCamera();
  }

  void checkInternetConnection() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        internetStatus.value = "";
      } else {
        internetStatus.value = "Internet is not available";
      }
    });
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (!hasScanned.value) {
        final scannedCode = scanData.code ?? '';
        scanUrl.value = scannedCode;
        hasScanned.value = true;

        animationController.stop();
        controller.pauseCamera();

        if (scannedCode.isNotEmpty && scannedCode.split('.').length == 3) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(scannedCode);
            print("ScanData----->${scanData.code}");
            String id = decodedToken['CustomerId'];
            customerId.value = id;


            await validateWashQr(id).then((value) async {

              clearScan();
            await  washStatusController.getTodayWashSummary();
              Get.back();
            /*  Get.offAllNamed(RouteStrings.dashboardScreen)?.then((val){
                washStatusController.getTodayWashSummary();

              });*/
            });
          } catch (e) {
            Get.snackbar("Error", "Failed to decode JWT: $e");
          }
        } else {
          Get.snackbar("Invalid QR", "Scanned code is not a valid JWT");
        }
      }
    });
  }

  void onQRViewCreatedOffer(QRViewController controller) {
    qrController = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (!hasScanned.value) {
        final scannedCode = scanData.code ?? '';
        print("ScanData----->${scanData.code}");
        scanUrl.value = scannedCode;
        hasScanned.value = true;

        animationController.stop();
        controller.pauseCamera();

        if (scannedCode.isNotEmpty && scannedCode.split('.').length == 3) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(scannedCode);
            String offerId = decodedToken['OfferId'];
            String id = decodedToken['CustomerId'];

            print("Extracted OfferId: $offerId");
            offerIdForReward.value = offerId;


            await validateOfferQr(id, offerId).then((value) async {

              clearScan();
              await getOffersById(int.parse(offerId));
              Get.back();

            });

          } catch (e) {
            print("Error decoding JWT: $e");
            Get.snackbar("Error", "Failed to decode JWT: $e");
          }
        } else {
          Get.snackbar("Invalid QR", "Scanned code is not a valid JWT");
        }
      }
    });
  }


/*  void onQRViewCreatedOffer(QRViewController controller) {
    qrController = controller;

    controller.scannedDataStream.listen((scanData) {
      final scannedCode = scanData.code ?? '';

      if (scannedCode.isNotEmpty) {
        print("Scanned Code String: $scannedCode");

        controller.pauseCamera();
        Get.back();
      } else {
        Get.snackbar("Error", "No data found in QR code.");
      }
    });
  }*/



  void clearScan() {
    scanUrl.value = '';
    customerId.value = '';
    hasScanned.value = false;

    qrController?.resumeCamera();
    animationController.repeat(reverse: true);
  }

  Future<dynamic> validateWashQr(String customerId) async {
    Map<String, dynamic> requestBody = {"customerId": customerId};
    try {
      isLoading.value = true;
      var response = await Repository().validateWashQrRepo(requestBody);
      print("Value received in controller validateWashQr: $response");
      return response;
    } catch (e) {
      print("Error in controller while validating QR: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> validateOfferQr(String customerId,String offerId) async {
    Map<String, dynamic> requestBody = {"customerId": customerId,
      "offerId":offerId


    };
    try {
      isLoading.value = true;
      var response = await Repository().validateOfferQrRepo(requestBody);
      print("Value received in controller validateWashQr: $response");
      return response;
    } catch (e) {
      print("Error in controller while validating QR: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    qrController?.dispose();
    animationController.dispose();
    super.onClose();
  }

  Rxn<GetOffersByIdModel> getOffersByIdModel = Rxn();

  Future<GetOffersByIdModel?> getOffersById(int id) async {
    try {

      getOffersByIdModel.value = await Repository().getOfferById(id);

      getOffersByIdModel.value;
    } catch (error) {


      print("Error fetching Offers by Di: $error");
    }
    return null;
  }

/// format discount value to string
  String formatDiscount(double? value) {
    if (value == null) return "";
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }
}
