import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiwash_worker/featuers/today_wash/controller/today_wash_controller.dart';
import 'package:hiwash_worker/generated/assets.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/route/route_strings.dart';
import 'package:hiwash_worker/styling/app_font_anybody.dart';
import 'package:hiwash_worker/widgets/components/app_dialog.dart';
import 'package:hiwash_worker/widgets/components/app_snack_bar.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../network_manager/local_storage.dart';
import '../../../network_manager/repository.dart';
import '../../../styling/app_color.dart';
import '../../../styling/app_font_poppins.dart';
import '../../../widgets/components/custom_swipe_button.dart';
import '../../../widgets/components/data_formet.dart';
import '../../../widgets/components/doted_horizontal_line.dart';
import '../../../widgets/components/image_view.dart';
import '../../../widgets/components/loader.dart';
import '../../today_wash/model/today_wash_summary_model.dart';
import '../model/get_offers_by_id_model.dart';

class QrController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  final TodayWashController todayWashController =
      Get.isRegistered<TodayWashController>()
          ? Get.find()
          : Get.put(TodayWashController());
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
  Rxn<Washes> washData = Rxn();
  late AnimationController animationController;
  late Animation<double> animation;

  final LocalStorage localStorage = LocalStorage();
  final TodayWashController washStatusController =
      Get.isRegistered<TodayWashController>()
          ? Get.find()
          : Get.put(TodayWashController());

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
          message: StringConstant.kCameraPermissionRequired.tr,
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
            int washId = 0;

            final result = await validateOfferQr(
              id,
              offerId,
              washId.toString(),
            );

            if (result != null) {
              Get.back();
              await getOffersById(int.parse(offerId));
              qRConfirmationDialog(
                heading: "Success",
                subHeeding: "Offer redeemed successfully",
                color: Colors.green,
              );
            } else {
              qRConfirmationDialog(
                heading: "Error",
                subHeeding: "Something went wrong please try again",
                color: Colors.red,
              );
            }
          } catch (e) {
            print("QR decode error: $e");
            qRConfirmationDialog(
              heading: "Error",
              subHeeding: "Invalid QR Code",
              color: Colors.red,
            );
          }
        } else {
          qRConfirmationDialog(
            heading: "Error",
            subHeeding: "Invalid QR Code",
            color: Colors.red,
          );
        }
      }
    });
  }

  /*
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
            int washId = 0;

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
            print("QR decode error: $e");
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
*/

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
            isLoading.value = true;

            var response = await validateWashQr(id);
            isLoading.value = false;

            if (response != null && response['success'] == true) {
              int washId = response['data']['washId'];
              print("Wash ID: $washId");

              await washStatusController.getCustomerDataById(int.parse(id));

              bool isPremium =
                  washStatusController
                      .getCustomerData
                      .value
                      ?.data
                      ?.subscriptionDetails
                      ?.isPremium ==
                  true;

              if (isPremium) {
                Get.back();
                Get.dialog(
                  newScanDialog(washData: washId.toString()),
                  barrierDismissible: false,
                );
              } else {
                try {
                  Get.back();
                  await todayWashController.completeWash(
                    washId.toString(),
                    requireImage: false,
                  ).then((value){
                    Get.back();
                    todayWashController.getTodayWashSummary();
                    qRConfirmationDialog(
                      heading: "Success",
                      subHeeding: "Wash Completed Successfully",
                      color: Colors.green,
                    );
                  });

                } catch (e) {
                  appSnackBar(message: "Error completing wash: $e");
                }
              }
            } else {
              Get.back();
              qRConfirmationDialog(
                color: Colors.red,
                heading: "Oops!",
                subHeeding:
                    response?['error']?['message'] ??
                    "It looks like you're out of washes. Visit us again next week",
              );
            }

            clearScan();
          } catch (e) {
            print("QR decode error: $e");
            Get.back();
            qRConfirmationDialog(
              color: Colors.red,
              heading: "Error",
              subHeeding: e.toString(),
            );
            clearScan();
          }
        } else {
          print("Invalid QR scanned");
          Get.back();
          qRConfirmationDialog(
            color: Colors.red,
            heading: "Error",
            subHeeding: "Invalid QR scanned",
          );
          clearScan();
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

  Future<dynamic> validateWashQr(String customerId) async {
    Map<String, dynamic> requestBody = {"customerId": customerId};

    try {
      isLoading.value = true;
      var response = await Repository().validateWashQrRepo(requestBody);

      if (response != null && response['success'] == true) {
        int washId = response['data']['washId'];
        TodayWashSummaryModel? summary =
            await todayWashController.getTodayWashSummary();
        if (summary != null &&
            summary.data != null &&
            summary.data!.washes != null) {
          final matchedWash = summary.data!.washes!.firstWhere(
            (wash) => wash.id == washId,
            orElse: () => Washes(id: washId),
          );

          washData.value = matchedWash;
        }
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

      qRConfirmationDialog({
        String? heading,
        String? subHeeding,
        Color? color,
      }) async {
        return showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: color ?? Colors.green,
              title: Text(heading ?? "", style: w500_18p(color: AppColor.white)),
              content: Text(subHeeding ?? '', style: w400_16p(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();

                    Get.offNamed(RouteStrings.dashboardScreen);
                  },
                  child: Text(
                    StringConstant.kOk.tr,
                    style: w700_16p(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      }

  Widget newScanDialog({required String washData}) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(() {
                return GestureDetector(
                  onTap: () async {
                    await todayWashController.pickImageFromCamera();

                    if (todayWashController.pickedImage.value != null) {
                      try {
                        await todayWashController
                            .completeWash(washData, requireImage: true)
                            .then((value) {
                              todayWashController.getTodayWashSummary();
                              Get.back();
                              qRConfirmationDialog(
                                heading: "Success",
                                subHeeding: "Wash Completed Successfully",
                                color: Colors.green,
                              );
                            });
                        todayWashController.getTodayWashSummary();
                        todayWashController.pickedImage.value = null;
                        //Get.back();
                      } catch (e) {
                        hideLoader();
                        appSnackBar(
                          message:
                              '${StringConstant.kErrorCompletingWash.tr} $e',
                        );
                      }
                    }
                  },
                  child: DottedBorder(
                    color: AppColor.c5C6B72.withOpacity(0.5),
                    strokeWidth: 1,
                    dashPattern: [4, 4],
                    radius: const Radius.circular(15),
                    borderType: BorderType.RRect,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.c5C6B72.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 144,
                      width: Get.width,
                      child:
                          todayWashController.pickedImage.value != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(
                                    todayWashController.pickedImage.value!.path,
                                  ),
                                  fit: BoxFit.fitWidth,
                                  width: double.infinity,
                                ),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.cC31848,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.cC31848.withOpacity(
                                            0.30,
                                          ),
                                          spreadRadius: 0,
                                          blurRadius: 15,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ImageView(
                                      path: Assets.iconsIcCamera,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  5.heightSizeBox,
                                  Text(
                                    StringConstant.kCaptureCarNumber.tr,
                                    style: w400_12p(color: AppColor.c455A64),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                    ),
                  ),
                );
              }),
            ),

            // Close button
          ],
        ),
      ),
    );
  }

  Widget subscriptionRowWidget({
    required String title,
    Color? color,
    required String packName,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.tr, style: w400_12p(color: AppColor.c455A64)),
        Text(packName.tr, style: w500_12p(color: color ?? AppColor.c2C2A2A)),
      ],
    );
  }
}

