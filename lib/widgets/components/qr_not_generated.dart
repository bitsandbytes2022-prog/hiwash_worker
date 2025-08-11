import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../language/String_constant.dart';
import '../../styling/app_color.dart';

class QrNotGenerated extends StatelessWidget {
   String? text;
   VoidCallback ?onTap;
   QrNotGenerated({super.key,  this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 216,
        height: 261,
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
              color: AppColor.c142293.withOpacity(0.1),
              blurRadius: 25,
              spreadRadius: 0,
            )]
        ),
        child: Center(child: Text(text??StringConstant.kQrNotGenerated.tr,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
