import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hiwash_worker/route/routes.dart';

import 'language/languages.dart';
import 'route/route_strings.dart';
import 'styling/app_theam.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale:Locale('en','US'),
          translations: Languages(),
          debugShowCheckedModeBanner: false,
          title: 'Hiwash worker',
          theme: LightTheme.theme(),
          // home: HomeScreen(),
          initialRoute: RouteStrings.splashScreen,
          getPages: Routes.pages,
        );
      },
    );
  }
}
