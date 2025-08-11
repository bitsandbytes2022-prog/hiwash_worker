import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hiwash_worker/featuers/rewads/view/rewarded_customers_screen.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/widgets/components/qr_not_generated.dart';

import '../../../route/route_strings.dart';
import '../controller/reward_controller.dart';

class RewardScreen extends StatelessWidget {
  RewardScreen({super.key});

  RewardController rewardController =
      Get.isRegistered() ? Get.find() : Get.put(RewardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
       () {
        return Column(
          children: [
            rewardController.isSelected.value
                ?  Container(
              padding: EdgeInsets.only(top: Get.height * 0.2),
                alignment: Alignment.center,
                child: QrNotGenerated(

                  text: "Scan QR to\nget reward",
                  onTap: (){
                    Get.toNamed(RouteStrings.qrScreen);
                  },
                ))
                : RewardedCustomersScreen()
          ],
        );
      }
    );
  }
}
