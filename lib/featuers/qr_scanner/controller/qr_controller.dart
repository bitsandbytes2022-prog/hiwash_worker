import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/featuers/today_wash/controller/wash_status_controller.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/widgets/components/app_snack_bar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../model/get_offers_by_id_model.dart';

class QrController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  RxMap<int, GetOffersByIdModel> scannedOffers =
      <int, GetOffersByIdModel>{}.obs;

  RxString scanUrl = ''.obs;
  RxString scanUrlOffer = ''.obs;
  RxString customerId = ''.obs;
  RxString offerIdForReward = ''.obs;
  RxString washIdIdForReward = ''.obs;
  RxString internetStatus = ''.obs;
  RxBool hasScanned = false.obs;
  RxBool hasScannedOffer = false.obs;
  Rxn<String> scannedCustomerId = Rxn<String>();
  Rxn<String> scannedOfferId = Rxn<String>();

  late AnimationController animationController;
  late Animation<double> animation;

  final LocalStorage localStorage = LocalStorage();
  final WashStatusController washStatusController =
      Get.isRegistered<WashStatusController>()
          ? Get.find()
          : Get.put(WashStatusController());

  var isLoading = false.obs;
  Rxn<GetOffersByIdModel> getOffersByIdModel = Rxn();
  Rxn<OffersByIList> offersByIList = Rxn();


  @override
  void onReady() async {
    super.onReady();
    await requestCameraPermission();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 150).animate(animationController);

    qrController?.resumeCamera();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var result = await Permission.camera.request();
      if (!result.isGranted) {
        appSnackBar(
          title: StringConstant.kPermissionDenied.tr,
          message: StringConstant.kCameraPermissionRequired.tr
        );

      }
    }
  }

  void onQRViewCreatedOffer(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!hasScannedOffer.value) {
        final scannedCode = scanData.code ?? '';
        scanUrlOffer.value = scannedCode;
        hasScannedOffer.value = true;
        animationController.stop();
        controller.pauseCamera();

        if (scannedCode.isNotEmpty && scannedCode.split('.').length == 3) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(scannedCode);
            String offerId = decodedToken['OfferId'];
            String id = decodedToken['CustomerId'];
            String washIdString = Get.arguments;
            int washId = int.parse(washIdString);

            final result = await validateOfferQr(
              id,
              offerId,
              washId.toString(),
            );

            if (result != null) {
              await getOffersById(int.parse(offerId));
              await Future.delayed(Duration(seconds: 1));
              Get.back();
            } else {
              await Future.delayed(Duration(seconds: 1));
              Get.back();
            }
          } catch (e) {
            await Future.delayed(Duration(seconds: 1));
            Get.back();
          }
        } else {
          await Future.delayed(Duration(seconds: 1));
          Get.back();
        }
      }
    });
  }

  void clearScan() {
    scanUrl.value = '';
    customerId.value = '';
    hasScanned.value = false;
    hasScannedOffer.value = false;
    offerIdForReward.value = '';
    washIdIdForReward.value = '';

    qrController?.resumeCamera();
    animationController.repeat(reverse: true);
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (!hasScanned.value) {
        final scannedCode = scanData.code ?? '';
        print("Scanned QR Code: $scannedCode");

        scanUrl.value = scannedCode;
        hasScanned.value = true;
        animationController.stop();
        controller.pauseCamera();

        if (scannedCode.isNotEmpty && scannedCode.split('.').length == 3) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(scannedCode);
            String id = decodedToken['CustomerId'];
            customerId.value = id;

            var response = await validateWashQr(id);
            if (response != null && response['success'] == false) {
              String errorMessage = response['error']['message'];
              await Future.delayed(Duration(seconds: 1));
              Get.back();
              print("Error: $errorMessage");
              clearScan();

            }
            clearScan();
            await washStatusController.getTodayWashSummary();
           // await Future.delayed(Duration(seconds: 1));
            Get.back();
          } catch (e) {
            await Future.delayed(Duration(seconds: 1));
            Get.back();
            print("QR error----->$e");
          }
        } else {
          await Future.delayed(Duration(seconds: 1));
          Get.back();
          print("Invalid QR Scanned code is not a valid JWT");
         // appSnackBar(message: "Something went wrong, try again");
        }
      }
    });
  }

  Future<dynamic> validateWashQr(String customerId) async {
    Map<String, dynamic> requestBody = {"customerId": customerId};
    try {
      isLoading.value = true;
      var response = await Repository().validateWashQrRepo(requestBody);
      if (response != null && response['success'] == false) {}else{
        await Future.delayed(Duration(seconds: 3));
        Get.back();
      }
      return response;
    } catch (e) {
      print("Error in validateWashQr: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> validateOfferQr(
    String customerId,
    String offerId,
    String washId,
  ) async {
    Map<String, dynamic> requestBody = {
      "customerId": customerId,
      "offerId": offerId,
      "washId": washId,
    };
    try {
      var response = await Repository().validateOfferQrRepo(requestBody);
      return response;
    } catch (e) {
      print("Error in validateOfferQr: $e");
      return null;
    } finally {
      // isLoading.value = false;
    }
  }

  Future<GetOffersByIdModel?> getOffersById(int id) async {
    try {
      getOffersByIdModel.value = await Repository().getOfferById(id);
      return getOffersByIdModel.value;
    } catch (e) {
      print("Error fetching offer by ID: $e");
      return null;
    }
  }

  String formatDiscount(double? value) {
    if (value == null) return "";
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
