import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hiwash_worker/featuers/dashboard/view/widget/second_drawer/second_drawer.dart';
import 'package:hiwash_worker/featuers/dashboard/view/widget/second_drawer/step_by_step_guide_screen.dart';
import 'package:hiwash_worker/featuers/profile/view/drawer_screen.dart';
import 'package:hiwash_worker/featuers/qr_scanner/view/qr_scanner.dart';
import 'package:hiwash_worker/featuers/rewads/controller/rewarded_customer_controller.dart';
import 'package:hiwash_worker/featuers/rewads/view/rewarded_customers_screen.dart';
import 'package:hiwash_worker/featuers/today_wash/controller/today_wash_controller.dart';
import 'package:hiwash_worker/featuers/today_wash/view/today_wash_screen.dart';
import 'package:hiwash_worker/generated/assets.dart';
import 'package:hiwash_worker/language/String_constant.dart';
import 'package:hiwash_worker/route/route_strings.dart';
import 'package:hiwash_worker/styling/app_color.dart';
import 'package:hiwash_worker/styling/app_font_anybody.dart';
import 'package:hiwash_worker/widgets/components/hi_wash_button.dart';
import 'package:hiwash_worker/widgets/components/image_view.dart';
import 'package:hiwash_worker/widgets/components/profile_image_container.dart';
import 'package:hiwash_worker/widgets/sized_box_extension.dart';

import '../../../styling/app_font_poppins.dart';
import '../../notification/view/notification_screen.dart';
import '../../rewads/controller/reward_controller.dart';
import '../../rewads/view/reward_screen.dart';

import '../../../widgets/components/app_home_bg.dart';
import '../controller/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentDrawer = 'first';
  final TodayWashController controller =
      Get.isRegistered<TodayWashController>()
          ? Get.find()
          : Get.put(TodayWashController());

  final RewardController rewardController =Get.isRegistered()?Get.find():Get.put(RewardController());
  RewardedCustomerController rewardedCustomerController =Get.isRegistered<RewardedCustomerController>()?Get.find<RewardedCustomerController>():Get.put(RewardedCustomerController());

  DashboardController dashboardController =
      Get.isRegistered<DashboardController>()
          ? Get.find()
          : Get.put(DashboardController());
  final List<Widget> _pages = [
    TodayWashScreen(),
    RewardedCustomersScreen(),
    StepByStepGuideScreen(showAppHomeBg: false,)
    //NotificationScreen(),
  ];

   List<String> get _headings => ["", StringConstant.kRewardedCustomers.tr,StringConstant.kStepByStep.tr];

  void _onItemTapped(int index) {
    if (index == 3) {
      _openDrawer('first');
    } else {
      setState(() {
        rewardedCustomerController.clearDateFilter();
        controller.isWashSelected.value = true;
        rewardController.isSelected.value=true;
        _currentIndex = index;
      });
    }
  }

  void _openDrawer(String drawerType) {
    setState(() {
      _currentDrawer = drawerType;
    });
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      print("Drawer scaffold state is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> filledImages = [
      fillNavigationImage(image: Assets.iconsIcHomeFill),
      fillNavigationImage(image: Assets.iconsIcRewardFill),
      fillNavigationImage(image: Assets.iconsIcGuideBook),
      Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColor.blue.withOpacity(0.2)),
        ),
        child: Obx(() {
          final profilePicUrl =
              dashboardController
                  .getWorkerModel
                  .value
                  ?.data
                  ?.first
                  .profilePicUrl ??
              '';
          final hasImage = profilePicUrl.isNotEmpty;
          return CircleAvatar(
            radius: 20,
            backgroundImage:
                hasImage
                    ? CachedNetworkImageProvider(
                      profilePicUrl,
                      headers: {'Cache-Control': 'no-cache'},
                    )
                    : AssetImage(Assets.imagesDemoProfile),
          );
        }),
      ),
    ];

    final List<Widget> outlineImages = [
      ImageView(path: Assets.iconsIcHome, height: 23, width: 23),
      ImageView(path: Assets.iconsTrophy, height: 23, width: 23),
      ImageView(path: Assets.iconsIcGuideBook, height: 23, width: 23),
      Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColor.blue.withOpacity(0.2)),
        ),
        child: Obx(() {
          final profilePicUrl =
              dashboardController
                  .getWorkerModel
                  .value
                  ?.data
                  ?.first
                  .profilePicUrl ??
              '';
          final hasImage = profilePicUrl.isNotEmpty;
          return CircleAvatar(
            radius: 20,
            backgroundImage:
                hasImage
                    ? CachedNetworkImageProvider(
                      profilePicUrl,
                      headers: {'Cache-Control': 'no-cache'},
                    )
                    : AssetImage(Assets.imagesDemoProfile),
          );
        }),
      ),
    ];

    return WillPopScope(
      onWillPop: ()async {
        return await _showExitConfirmationDialog(context);
      },
      child: SafeArea(
        bottom: true,


        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: _currentDrawer == 'first' ? DrawerScreen() : SecondDrawer(),
          drawerEnableOpenDragGesture: false,
      
          body: AppHomeBg(
            buttonPadding:
                _currentIndex == 0
                    ? EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 30): EdgeInsets.only(left: 16, right: 16, top: 40),
            iconLeft: SizedBox(),
            headingText: _headings[_currentIndex],

            childAppBar:
                _currentIndex == 0
                    ? Obx(
                      () => Container(
                        margin: EdgeInsets.only(left: 25, right: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  controller.isWashSelected.value = true;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.isWashSelected.value
                                            ? AppColor.cF6F7FF
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    StringConstant.kToday.tr,
                                    style: w700_16a(
                                      color:
                                          controller.isWashSelected.value
                                              ? AppColor.c2C2A2A
                                              : AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            20.widthSizeBox,
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.isWashSelected.value = false;
                                  controller.washLog(
                                    controller.defaultStartDate.toIso8601String(),
                                    controller.defaultEndDate.toIso8601String(),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        !controller.isWashSelected.value
                                            ? AppColor.cF6F7FF
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    StringConstant.kWashLog.tr,
                                    style: w700_16a(
                                      color:
                                          !controller.isWashSelected.value
                                              ? AppColor.c2C2A2A
                                              : AppColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):

                     SizedBox(),
            iconRight: _currentIndex == 2
                ? SizedBox()
                : GestureDetector(
              onTap: () {
                setState(() {
                  controller.isWashSelected.value = true;
                  Get.toNamed(
                    RouteStrings.stepByStepGuideScreen,
                    arguments: {'showAppHomeBg': true},
                  );
                });
              },
              child: ImageView(
                height: 23,
                width: 23,
                path: Assets.iconsIcGuideBook,
                color: Colors.white,
              ),
            ),
            floatingActionButton: _currentIndex == 1
                ? GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return RewardScreen();
                  },
                );
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColor.cC31848,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.cC31848.withOpacity(0.60),
                      spreadRadius: 0,
                      blurRadius: 30,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: Center(
                  child: ImageView(
                    path: Assets.iconsIcQrScanner,
                    height: 28,
                    width: 28,
                  ),
                ),
              ),
            )
                : null,



            child: _pages[_currentIndex],
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: filledImages.length,
            tabBuilder: (int index, bool isActive) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [isActive ? filledImages[index] : outlineImages[index]],
              );
            },
            activeIndex: _currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            onTap: _onItemTapped,
            backgroundColor: AppColor.blue,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return QrScreen();
                },
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.cC31848,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.cC31848.withOpacity(0.60),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: Center(
                child: ImageView(
                  path: Assets.iconsIcQrScanner,
                  height: 28,
                  width: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fillNavigationImage({required String image}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.c000000.withOpacity(0.70),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ImageView(path: image, height: 25, width: 25),
    );
  }
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringConstant.kConfirmExit.tr,style: w700_22a(color: AppColor.c2C2A2A),),
          content: Text(StringConstant.kDoYouReally.tr,style: w400_16p(),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(StringConstant.kNo.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(StringConstant.kYes.tr),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
