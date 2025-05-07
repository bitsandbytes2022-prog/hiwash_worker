import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/styling/app_color.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../controller/qr_controller.dart';

class RewardQrScreen extends StatelessWidget {
  RewardQrScreen({super.key});

  final QrController controller = Get.put(QrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cF6F7FF.withOpacity(0.2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: controller.clearScan,
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Container(
              alignment: Alignment.center,
              width: Get.width / 1.2,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QRView(
                    key: controller.qrKey,
                    onQRViewCreated: controller.onQRViewCreatedOffer,

                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      overlayColor: AppColor.c101D8D.withOpacity(0.5),
                      borderRadius: 10,
                      borderLength: 50,
                      borderWidth: 20,
                      cutOutSize: 300,
                    ),
                  ),
                  Obx(() {
                    if (controller.scanUrl.value.isEmpty &&
                        controller.animationController != null &&
                        controller.animationController.isAnimating) {
                      return AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Positioned(
                            top: controller.animation.value,
                            child: Container(
                              width: 280,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColor.cFFC727,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Column(
              children: [
                Text(
                  controller.offerIdForReward.value.isNotEmpty
                      ? 'Reward ID: ${controller.offerIdForReward.value}'
                      : 'Scan a QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                if (controller.internetStatus.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      controller.internetStatus.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          Obx(() {
            print("ScanUrl----->${controller.scanUrl.value}");
            return Text(
              controller.scanUrl.value.isNotEmpty
                  ? 'Scanned URL: ${controller.scanUrl.value}'
                  : 'No URL scanned yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            );
          }),
        ],
      ),
    );
  }
}
