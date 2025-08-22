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
/*
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
              print("Print------>$washId");
              washStatusController.getCustomerDataById(int.parse(id)).then((
                value,
              ) {
                bool isPremium = washStatusController
                    .getCustomerData.value?.data?.subscriptionDetails?.isPremium ==
                    true;
                Get.back();

                Get.dialog(
                  newScanDialog(washData: washId.toString()),
                  barrierDismissible: false,
                );

              });
            } else {
              Get.back();
              qRConfirmationDialog(
                color: Colors.red,
                heading: "Oops!",
                subHeeding:
                    response?['error']?['message'] ??
                    "It looks like you're out of washes. Visit us again in next week",
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
          print("Invalid QR scanned: Not JWT format");
          Get.back();
          qRConfirmationDialog(
            color: Colors.red,
            heading: "Error",
            subHeeding: "Invalid QR scanned: Not JWT format",
          );
          clearScan();
        }
      }
    });
  }
*/
/*
  Future<dynamic> validateWashQr(String customerId) async {
    Map<String, dynamic> requestBody = {"customerId": customerId};
    try {
      isLoading.value = true;
      var response = await Repository().validateWashQrRepo(requestBody);
      if (response != null && response['success'] == false) {}else{
     */
/*   await Future.delayed(Duration(seconds: 3));
        Get.back();*/ /*

      }
      return response;
    } catch (e) {
      print("Error in validateWashQr: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }
*/
/* void onQRViewCreated(QRViewController controller) {
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
        }
      }
    });
  }*/

/* Widget newScanDialog({required String washData}) {
   getOffersByIdModel.value = null;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 11,
                        top: 11,
                      ),
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // padding: EdgeInsets.symmetric(horizontal: 27),
                      child: Obx(() {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  37.heightSizeBox,
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            color: AppColor.blue.withOpacity(0.2),
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey[200],
                                          backgroundImage:
                                          (  todayWashController
                                              .getCustomerData
                                              .value
                                              ?.data
                                              ?.customerDetails?.profilePicUrl
                                              ?.isNotEmpty ??
                                              false)
                                              ? AssetImage(
                                            Assets.imagesDemoProfile,
                                          ) */ /*NetworkImage(
                                            todayWashController
                                                .getCustomerData
                                                .value
                                                ?.data
                                                ?.customerDetails!.profilePicUrl!,
                                          )*/ /*
                                              : AssetImage(
                                            Assets.imagesDemoProfile,
                                          ),
                                        ),
                                      ),

                                      todayWashController
                                          .getCustomerData
                                          .value
                                          ?.data
                                          ?.subscriptionDetails?.isPremium == true
                                          ? Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            color: AppColor.cE8E9F4,
                                          ),
                                        ),

                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundImage: AssetImage(
                                            Assets.iconsIcCrown,
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                    ],
                                  ),
                                  11.heightSizeBox,

                                  Text(
                                    todayWashController
                                        .getCustomerData
                                        .value
                                        ?.data?.customerDetails?.fullName ?? "",
                                    style: w700_16a(color: AppColor.c2C2A2A),
                                    textAlign: TextAlign.center,
                                  ),

                                  15.heightSizeBox,
                                  subscriptionRowWidget(
                                    title: StringConstant.kPackName.tr,
                                    packName:
                                    todayWashController
                                        .getCustomerData
                                        .value
                                        ?.data
                                        ?.subscriptionDetails
                                        ?.subscriptionName ??
                                        '',
                                  ),
                                  10.heightSizeBox,
                                  DotedHorizontalLine(),
                                  10.heightSizeBox,
                                  subscriptionRowWidget(
                                    title: StringConstant.kExpiryDate.tr,
                                    packName: formatDate(
                                      todayWashController
                                          .getCustomerData
                                          .value
                                          ?.data
                                          ?.subscriptionDetails
                                          ?.endDate,
                                    ),
                                  ),
                                  10.heightSizeBox,
                                  DotedHorizontalLine(),
                                  10.heightSizeBox,
                                  subscriptionRowWidget(
                                    title: StringConstant.kCarNumber.tr,
                                    packName:
                                    todayWashController
                                        .getCustomerData
                                        .value
                                        ?.data
                                        ?.customerDetails
                                        ?.carNumber ??
                                        '',
                                  ),
                                  10.heightSizeBox,
                                  DotedHorizontalLine(),
                                  10.heightSizeBox,
                                */ /*  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        StringConstant.kReward.tr,
                                        style: w400_12p(color: AppColor.c455A64),
                                      ),

                                      (
                                          getOffersByIdModel
                                          .value
                                          ?.offersByIList
                                          ?.first
                                          .title ==
                                          null ||

                                              getOffersByIdModel
                                              .value!
                                              .offersByIList!
                                              .first
                                              .title
                                              .toString()
                                              .isEmpty)
                                          ? GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            RouteStrings.rewardQrScreen,
                                            arguments: washData.id.toString(),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColor.cD83030,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(40),
                                          ),
                                          child: Row(
                                            children: [
                                              ImageView(
                                                path: Assets.iconsIcQr,
                                                height: 14,
                                                width: 14,
                                              ),
                                              7.widthSizeBox,
                                              Text(
                                                StringConstant.kScanOffer.tr,
                                                style: w500_12a(
                                                  color: AppColor.c142293,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          : Text(

                                            getOffersByIdModel
                                            .value
                                            ?.offersByIList
                                            ?.first
                                            .title ??
                                            '',
                                        */ /**/ /* "Flat ${qrController.formatDiscount(qrController.getOffersByIdModel.value?.data?.first.discountValue)}% off",*/ /**/ /*
                                        style: w500_14a(
                                          color: AppColor.c1F9D70,
                                        ),
                                      ),
                                    ],
                                  ),*/ /*

                                  32.heightSizeBox,
                                ],
                              ),
                            ),
                            if (todayWashController
                                .getCustomerData
                                .value
                                ?.data
                                ?.subscriptionDetails
                                ?.subscriptionId ==
                                2)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.cF6F7FF,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    DotedHorizontalLine(),

                                    32.heightSizeBox,

                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 5,
                                            left: 16,
                                            right: 16,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.zero,
                                            child: GestureDetector(
                                              onTap: () {
                                                todayWashController.pickImageFromCamera();
                                              },
                                              child: DottedBorder(
                                                color: AppColor.c5C6B72
                                                    .withOpacity(0.5),
                                                strokeWidth: 1,
                                                dashPattern: [4, 4],
                                                radius: Radius.circular(15),
                                                borderType: BorderType.RRect,
                                                child: Container(
                                                  //margin: EdgeInsets.symmetric(horizontal: 50),
                                                  //color: Colors.green,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.c5C6B72
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                  ),
                                                  height: 144,
                                                  width: Get.width,
                                                  child: Obx(() {
                                                    if (todayWashController
                                                        .pickedImage
                                                        .value !=
                                                        null) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                        child: Image.file(
                                                          File(
                                                            todayWashController
                                                                .pickedImage
                                                                .value!
                                                                .path,
                                                          ),
                                                          fit: BoxFit.fitWidth,
                                                          width: double.infinity,
                                                        ),
                                                      );
                                                    } else {
                                                      return Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            padding:
                                                            EdgeInsets.all(
                                                              15,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              shape:
                                                              BoxShape.circle,
                                                              color:
                                                              AppColor
                                                                  .cC31848,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: AppColor
                                                                      .cC31848
                                                                      .withOpacity(
                                                                    0.30,
                                                                  ),
                                                                  spreadRadius: 0,
                                                                  blurRadius: 15,
                                                                  offset: Offset(
                                                                    0,
                                                                    10,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            child: ImageView(
                                                              path:
                                                              Assets
                                                                  .iconsIcCamera,
                                                              height: 20,
                                                              width: 20,
                                                            ),
                                                          ),
                                                          5.heightSizeBox,
                                                          Text(
                                                            StringConstant
                                                                .kCaptureCarNumber
                                                                .tr,
                                                            style: w400_12p(
                                                              color:
                                                              AppColor
                                                                  .c455A64,
                                                            ),
                                                            textAlign:
                                                            TextAlign.center,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  }),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        (todayWashController.pickedImage.value != null)
                                            ? Positioned(
                                          right: 10,
                                          child: ImageView(
                                            path: Assets.iconsIcVerify,
                                            height: 25,
                                            width: 25,
                                          ),
                                        )
                                            : SizedBox(),
                                      ],
                                    ),

                                    30.heightSizeBox,

                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CustomSwipeButton(
                                          thumbPadding: EdgeInsets.all(3),
                                          activeThumbColor: AppColor.c1F9D70,
                                          thumb: Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                          ),
                                          elevationThumb: 2,
                                          elevationTrack: 2,
                                          child: Text(
                                            StringConstant.kSwipeToCompleteWash.tr.toUpperCase(),
                                            style: TextStyle(
                                              color: AppColor.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onSwipe: () async {
                                            if (todayWashController.pickedImage.value == null) {
                                              appSnackBar(message: "Please capture car number first");
                                              return; // Swipe ka process stop
                                            }

                                            try {
                                              await todayWashController.completeWash(
                                                washData,
                                                requireImage: true,
                                              ).then((value) async {
                                                todayWashController.getTodayWashSummary();
                                                todayWashController.pickedImage.value = null;
                                                Get.back();
                                                Get.back();
                                              });
                                            } catch (e) {
                                              hideLoader();
                                              appSnackBar(
                                                message: '${StringConstant.kErrorCompletingWash.tr}$e',
                                              );
                                            }
                                          },
                                        )


                                        */ /*CustomSwipeButton(
                                          thumbPadding: EdgeInsets.all(3),
                                          activeThumbColor: AppColor.c1F9D70,
                                          thumb: Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                          ),
                                          elevationThumb: 2,
                                          elevationTrack: 2,
                                          child: Text(
                                            StringConstant.kSwipeToCompleteWash.tr
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: AppColor.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onSwipe: () async {
                                            try {
                                              await todayWashController
                                                  .completeWash(
                                               washData,
                                                requireImage: true,
                                              )
                                                  .then((value) async {
                                                todayWashController.getTodayWashSummary();
                                                //await qrController.getOffersById(int.parse(washData.id.toString()));
                                                // await  controller.getCustomerDataById(int.parse(washData.customerId.toString()));
                                                todayWashController.pickedImage.value =
                                                null;
                                                Get.back();
                                                Get.back();


                                              });
                                            } catch (e) {
                                              hideLoader();
                                              appSnackBar(
                                                message:
                                                '${StringConstant.kErrorCompletingWash.tr}${e}',
                                              );
                                            }
                                          },
                                        ),*/ /*
                                      ),
                                    ),

                                    46.heightSizeBox,
                                  ],
                                ),
                              )
                            else
                              Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: CustomSwipeButton(
                                        thumbPadding: EdgeInsets.all(3),
                                        activeThumbColor: AppColor.c1F9D70,
                                        thumb: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                        ),
                                        elevationThumb: 2,
                                        elevationTrack: 2,
                                        child: Text(
                                          "${StringConstant.kSwipeToCompleteWash.tr}"
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onSwipe: () async {
                                          try {
                                            //  Get.back();
                                            await todayWashController
                                                .completeWash(
                                             washData,
                                            )
                                                .then((va) async {
                                              todayWashController
                                                  .getTodayWashSummary();

                                              await todayWashController
                                                  .getCustomerDataById(
                                                int.parse(
                                                washData,
                                                ),
                                              );
                                              Get.back();

                                            });
                                          } catch (e) {
                                            hideLoader();
                                            appSnackBar(
                                              message:
                                              '${StringConstant.kErrorCompletingWash.tr}${e}',
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  32.heightSizeBox,
                                ],
                              ),
                          ],
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: () {
                        */ /*      controller.pickedImage.value = null;
                        qrController.getOffersByIdModel.value = null;*/ /*
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 21, top: 18),
                        child: ImageView(
                          path: Assets.iconsIcClose,
                          height: 28,
                          width: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            todayWashController
                .getCustomerData
                .value
                ?.data
                ?.subscriptionDetails
                ?.subscriptionId ==
                1
                ? Container(
              padding: EdgeInsets.only(top: 0),
              margin: EdgeInsets.only(left: 50, right: 50),

              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(Assets.imagesDiloagBgTop),

                  RichText(
                    text: TextSpan(
                      text: StringConstant.kRemainingWash.tr,
                      style: w500_14p(color: AppColor.c2C2A2A),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                          todayWashController
                              .getCustomerData
                              .value
                              ?.data
                              ?.subscriptionDetails
                              ?.remainingWashes
                              .toString(),
                          style: w400_16p(color: AppColor.cC31848),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }*/
