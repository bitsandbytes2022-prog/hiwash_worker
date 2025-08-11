import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      "kWelcomeToThe": "Welcome to the",
      "kHiWASH": "HI WASH",
      "kWeComeToYouTo": "We come to you to\nwash your car...!!",

      ///  welcome screen
      "kEliteCarWash": "Elite car wash service",
      "kEarnMoreGetRewardsAndEnjoyExclusiveWorkerBenefits":
          "Earn more, get rewards, and enjoy\nexclusive worker benefits!",
      "kGetStarted": "Get Started",
      "kSkip": "Skip",
      "kTermsAndConditions": "Terms & Conditions",
      "kTermsAndCondition": "Terms & Condition",
      "kWashWin": "Wash & Win!",
      "kGetYourCarWashed":
          "Get your car washed weekly at 100+ locations with exclusive offers.Missed washes still deducted.",
      "kMissedWashesStillDeducted": "Missed washes still deducted.",
      "kLetMakeEvery": "Let's Make Every Car Shine!",

      ///  Login screen
      "kLogin": "Log In!",
      "kWelcomeBack": "Welcome Back,",
      "kEmail": "Email",
      "kPassword": "Password",
      "kForgotPassword": "Forgot Password?",
      "kLogIn": "Log In",
      "kDontAaveAccount": "Don’t have account? ",
      "SIGNUP": "SIGN UP",
      "kOR": "OR",
      "kPLeaseEnterValid": "Please Enter A Valid Email",
      "kPhoneNumberCannotBeEmpty": "Phone number cannot be empty",

      /// SIgn up screen
      "kHello": "Hello,",
      "kSignUp": "Sign Up!",
      "kName": "Name",
      "kPhone": "Phone",
      "kConfirmPassword": "Confirm Password ",
      "signUp": "Sign Up",
      "kEnterYourFullName": "Enter your full name",
      "kEnterYourEmail": "Enter your email",
      "kEnterPhoneNumber": "Enter phone number",

      /// forgot password screen
      "kForgot": "Forgot",
      "kEnterRegisteredPhone": "Enter Registered Phone",
      "kEnterThePhoneNumber":
          "Enter the phone number\nassociated with your account",
      "kEnterYourPhoneNumber": "Enter your phone number",
      "kRecoverPassword": "Recover password",

      /// otp screen
      "kAuthentication": "Authentication",
      "kOTP": "OTP",
      "kVerifyPhone": "Verify Phone",
      "kCodeHasBeenSentTo": 'Code has been sent to ',
      "kDidGetOTPCode": "Didn't get OTP Code ?",
      "kVerify": "Verify",
      "kTestOTP": "TEST OTP: ",

      "KResendCode": "RESEND CODE",
      "kInvalidOTP": "Invalid OTP",
      "kError": "Error",
      "kSomethingWentWrong": "Something went wrong",
      "kPleaseEnterTheCorrectOTP": "Please enter the correct OTP",
      "kEnterValidOTP": "Enter valid OTP",
      "kSuccess": "Success",

      /// Reset password screen
      "kReset": "Reset",
      "kCreateNewPassword": "Create New Password",
      "kYourNewPasswordMust":
          "Your New Password Must be different\nfrom Previously used password",
      "kSave": "Save",

      ///Reward screen
      "kSortByExpiry": "Sort by Expiry",
      "kAscendingOrder": "Ascending Order",
      "kDescendingOrder": "Descending Order",
      "kNoExpiry": "No Expiry",
      "kExpired": "Expired",
      "kYears": "years",
      "kMonths": "months",
      "kDays": "days",
      "kHours": "hours",
      "kHour": "hour",
      "kMinutes": "minutes",
      "kMinute": "minute",
      "kSeconds": "seconds",
      "kSecond": "second",
      "kInvalidDate": "Invalid date",

      /// faq screen
      "kFAQ": "FAQ’s",
      "kSearch": "Search...",
      "kNoFAQsFound": "No FAQs found",

      /// Second Drawer
      "kGetHelp": "Get Help?",
      "kCouldNotLaunch": "Could not launch",
      "kChatWithSupport": 'Chat with Support',
      "kHelpDeskTicket": 'Help Desk Ticket',
      "kStepByStep": 'Step-by-Step Guide',

      /// step by step screen
      "kNoTitle": 'No Title',
      "kNoDescription": 'No Description',
      "kStepByStepGuideDetail": "Step-by-Step Guide - Detail",
      "kStepByStepGuide": "Step-by-Step Guide",

      /// Dashboard screen
      "kOffersForYou": "Offers For You",
      "kNotification": "Notification’s",
      "kRedeemWash": "Redeem Wash!",
      "kScanYourQR": "Scan Your QR Code to\nEnjoy Your Wash.",
      "kConfirmExit": "Confirm Exit",
      "kDoYouReally": "Do you really want to close the app?",
      "kNo": "No",
      "kYes": "Yes",
      "kRewardedCustomers": "Rewarded Customers",
      "kToday": "Today",
      "kWashLog": "Wash Log",

      /// Notification screen
      "kProvisionalPermissionGranted": "Provisional Permission Granted",
      "kYouWillReceive":
          "You will receive notifications, but they may be limited.",
      "kNotificationPermissionDenied": "Notification Permission Denied",
      "kPleaseAllow": "Please allow notifications to receive updates.",
      "kFailedToRequest": "Failed to request notification permission.",
      "kNotificationClicked": "Notification Clicked",
      "kNoRouteFound": "No route found in notification.",
      "kNoNotificationFound": "No Notifications Found",
      "kYour": 'Your ',
      "kPackHasBeenOverdueSince": ' Pack Has\n Been Overdue Since',
      "UserGrantedPermission": "User granted permission",

      /// Profile Screen
      "kProfileUpdatedSuccessfully": 'Profile updated successfully',
      "kPackExpiringIn": ' pack\nexpiring in ',
      "kMyAccount": 'My Account',
      "kSubscriptionPlan": 'Subscription Plan',
      "kTheme": 'Theme',
      "kLanguage": 'Language',
      "kPrivacySettings": 'Privacy Policy',
      "kLogout": "Logout",
      "kArabic": "Arabic",
      "kEnglish": "English",
      "kSelectImageSource": "Select Image Source",
      "kCamera": "Camera", "kGallery": "Gallery",
      "kPleaseEnterYourName": 'Please enter your name',
      "kPleaseEnterYourEmail": 'Please enter your email',
      "kPleaseEnterYourPhone": 'Please enter your phone',
      "kCarNumber": "Car Number",
      'kPackName': 'Pack Name ',

      "kRemainingWash": "Remaining wash",
      "kRemaining": "Remaining",
      'kExpiryDate': 'Expiry date ',
      "kUpgradeYourPlanNow": "upgrade your Plan now",
      "kNoPlansAvailable": "No plans available",
      "kYouCanRenewYourSubscriptionOnlyWithin7DaysOfExpiry":
          "You can renew your subscription only within 7 days of expiry.",
      "kRenewNow": "Renew Now",
      "kYear": "/ Year",
      "kRenewalNotAvailable": "Renewal Not Available",
      "kNoPlanSelected": "No plan selected.",
      'kEmployeeIDNO': 'Employee ID NO: ',
      "kAddress": "Address",
      "kPermissionDenied": "Permission Denied",
      "kCameraPermissionRequired":
          "Camera permission is required to scan QR codes.",

      /// QR screen
      "kClear": "Clear",
      "kScanAQRCode": 'Scan a QR code',
      "kCustomerID": "Customer ID: ",
      "kRewardID": "Reward ID:",
      "kRewardScreen": "Reward Screen",
      "kPleaseCaptureAnImage": "Please capture an image.",

      ///Today Screen
      "kReward": "Reward",
      "kScanOffer": "Scan Offer",
      "kCaptureCarNumber": "Capture Car Number Plate\nAnd Verify",
      "kSwipeToCompleteWash": "Swipe to Complete Wash ",
      "kErrorCompletingWash": "Error completing wash:",
      "kWashComplete": "Wash Complete!",
      "kShareYourFeedback": "Share your feedback and\nrate the Customer.",
      "kEnterYourCommentHere": "Enter your comment here...",
      "kSubmit": "Submit",
      "kTodayWashes": "Today Washes",
      "kComplete": "Complete",

      /// app component
      'kRemainingWashes': 'Remaining Washes: ',
      "kDateIsNotFound": 'Data is not found',
      "kOfferDetails": "Offer Details",
      "kHowToRedeem": "How to redeem",
      "kReportAnIssue": "Report an issue",
      "kYourRewardHasBeen": "Your Reward Has Been\nSuccessfully Redeemed!",
      "kDay": "Day",
      "kHRS": "HRS",
      "kMINS": "MINS",
      "kQrNotGenerated": "Qr Not\nGenerated",
      "kSuccesss": "Success!",
      "kPlanIsNowActivated": " plan is now activated.",
      "kScanToUnlockWeekly":
          "Scan to unlock weekly washes,\nexclusive offers, and amazing deals!",
      "kYourPaymentIsComplete": "Your payment is complete, and your\n",
      "kJan": "Jan",
      "kFev": "Feb",
      "kMar": "Mar",
      "kApr": "Apr",
      "kMay": "May",
      "kJun": "Jun",
      "kJul": "Jul",
      "kAug": "Aug",
      "kSep": "Sep",
      "kAct": "Oct",
      "kNov": "Nov",
      "kDec": "Dec",
      "kOk": "Ok",
    },

  /*  'ar_SA': {
      "kWelcomeToThe": "مرحباً بكم في",
      "kHiWASH": "هاي واش",
      "kWeComeToYouTo": "نأتي إليكم لنقوم\nبغسل سيارتكم...!!",

      ///  welcome screen
      "kEliteCarWash": "خدمة غسيل السيارات المتميزة",
      "kEarnMoreGetRewardsAndEnjoyExclusiveWorkerBenefits":
          "اكسب أكثر، احصل على مكافآت، واستمتع\nبمزايا حصرية للعاملين!",
      "kGetStarted": "ابدأ الآن",
      "kSkip": "تخطي",
      "kTermsAndConditions": "الأحكام والشروط",
      "kTermsAndCondition": "الأحكام والشروط",
      "kWashWin": "اغسل واربح!",
      "kGetYourCarWashed":
          "اغسل سيارتك أسبوعياً في أكثر من 100 موقع مع عروض حصرية. الغسلات المفقودة تُخصم أيضاً.",
      "kMissedWashesStillDeducted": "الغسلات المفقودة تُخصم أيضاً.",
      "kLetMakeEvery": "دعونا نجعل كل سيارة تتألق!",

      ///  Login screen
      "kLogin": "تسجيل الدخول!",
      "kWelcomeBack": "أهلاً بعودتك،",
      "kEmail": "البريد الإلكتروني",
      "kPassword": "كلمة المرور",
      "kForgotPassword": "نسيت كلمة المرور؟",
      "kLogIn": "تسجيل الدخول",
      "kDontAaveAccount": "ليس لديك حساب؟ ",
      "SIGNUP": "إنشاء حساب",
      "kOR": "أو",
      "kPLeaseEnterValid": "يرجى إدخال بريد إلكتروني صحيح",
      "kPhoneNumberCannotBeEmpty": "رقم الهاتف لا يمكن أن يكون فارغاً",

      /// SIgn up screen
      "kHello": "مرحباً،",
      "kSignUp": "إنشاء حساب!",
      "kName": "الاسم",
      "kPhone": "الهاتف",
      "kConfirmPassword": "تأكيد كلمة المرور",
      "signUp": "إنشاء حساب",
      "kEnterYourFullName": "أدخل اسمك الكامل",
      "kEnterYourEmail": "أدخل بريدك الإلكتروني",
      "kEnterPhoneNumber": "أدخل رقم الهاتف",

      /// forgot password screen
      "kForgot": "نسيت",
      "kEnterRegisteredPhone": "أدخل الهاتف المسجل",
      "kEnterThePhoneNumber": "أدخل رقم الهاتف\nالمرتبط بحسابك",
      "kEnterYourPhoneNumber": "أدخل رقم هاتفك",
      "kRecoverPassword": "استرداد كلمة المرور",

      /// otp screen
      "kAuthentication": "المصادقة",
      "kOTP": "رمز التحقق",
      "kVerifyPhone": "تحقق من الهاتف",
      "kCodeHasBeenSentTo": 'تم إرسال الرمز إلى ',
      "kDidGetOTPCode": "لم تستلم رمز التحقق؟",
      "kVerify": "تحقق",
      "kTestOTP": "رمز التحقق التجريبي: ",

      "KResendCode": "إعادة إرسال الرمز",
      "kInvalidOTP": "رمز تحقق غير صحيح",
      "kError": "خطأ",
      "kSomethingWentWrong": "حدث خطأ ما",
      "kPleaseEnterTheCorrectOTP": "يرجى إدخال رمز التحقق الصحيح",
      "kEnterValidOTP": "أدخل رمز تحقق صحيح",
      "kSuccess": "نجح",

      /// Reset password screen
      "kReset": "إعادة تعيين",
      "kCreateNewPassword": "إنشاء كلمة مرور جديدة",
      "kYourNewPasswordMust":
          "كلمة المرور الجديدة يجب أن تكون مختلفة\nعن كلمة المرور المستخدمة سابقاً",
      "kSave": "حفظ",

      ///Reward screen
      "kSortByExpiry": "ترتيب حسب انتهاء الصلاحية",
      "kAscendingOrder": "ترتيب تصاعدي",
      "kDescendingOrder": "ترتيب تنازلي",
      "kNoExpiry": "بلا انتهاء صلاحية",
      "kExpired": "منتهي الصلاحية",
      "kYears": "سنوات",
      "kMonths": "أشهر",
      "kDays": "أيام",
      "kHours": "ساعات",
      "kHour": "ساعة",
      "kMinutes": "دقائق",
      "kMinute": "دقيقة",
      "kSeconds": "ثواني",
      "kSecond": "ثانية",
      "kInvalidDate": "تاريخ غير صحيح",

      /// faq screen
      "kFAQ": "الأسئلة الشائعة",
      "kSearch": "بحث...",
      "kNoFAQsFound": "لم يتم العثور على أسئلة شائعة",

      /// Second Drawer
      "kGetHelp": "الحصول على المساعدة؟",
      "kCouldNotLaunch": "تعذر التشغيل",
      "kChatWithSupport": 'محادثة مع الدعم',
      "kHelpDeskTicket": 'تذكرة مكتب المساعدة',
      "kStepByStep": 'دليل خطوة بخطوة',

      /// step by step screen
      "kNoTitle": 'بلا عنوان',
      "kNoDescription": 'بلا وصف',
      "kStepByStepGuideDetail": "دليل خطوة بخطوة - التفاصيل",
      "kStepByStepGuide": "دليل خطوة بخطوة",

      /// Dashboard screen
      "kOffersForYou": "عروض خاصة بك",
      "kNotification": "الإشعارات",
      "kRedeemWash": "استبدال الغسلة!",
      "kScanYourQR": "امسح رمز الاستجابة السريعة\nللاستمتاع بغسلتك.",
      "kConfirmExit": "تأكيد الخروج",
      "kDoYouReally": "هل تريد حقاً إغلاق التطبيق؟",
      "kNo": "لا",
      "kYes": "نعم",
      "kRewardedCustomers": "العملاء المكافئون",
      "kToday": "اليوم",
      "kWashLog": "سجل الغسيل",

      /// Notification screen
      "kProvisionalPermissionGranted": "تم منح إذن مؤقت",
      "kYouWillReceive": "ستتلقى إشعارات، لكنها قد تكون محدودة.",
      "kNotificationPermissionDenied": "تم رفض إذن الإشعارات",
      "kPleaseAllow": "يرجى السماح بالإشعارات لتلقي التحديثات.",
      "kFailedToRequest": "فشل في طلب إذن الإشعارات.",
      "kNotificationClicked": "تم النقر على الإشعار",
      "kNoRouteFound": "لم يتم العثور على مسار في الإشعار.",
      "kNoNotificationFound": "لم يتم العثور على إشعارات",
      "kYour": 'باقتك ',
      "kPackHasBeenOverdueSince": ' أصبحت\n متأخرة منذ',
      "UserGrantedPermission": "المستخدم منح الإذن",

      /// Profile Screen
      "kProfileUpdatedSuccessfully": 'تم تحديث الملف الشخصي بنجاح',
      "kPackExpiringIn": ' الباقة\nتنتهي خلال ',
      "kMyAccount": 'حسابي',
      "kSubscriptionPlan": 'خطة الاشتراك',
      "kTheme": 'المظهر',
      "kLanguage": 'اللغة',

      "kPrivacySettings": 'سياسة الخصوصية',
      "kLogout": "تسجيل الخروج",
      "kArabic": "العربية",
      "kEnglish": "الإنجليزية",
      "kSelectImageSource": "اختر مصدر الصورة",
      "kCamera": "الكاميرا", "kGallery": "المعرض",
      "kPleaseEnterYourName": 'يرجى إدخال اسمك',
      "kPleaseEnterYourEmail": 'يرجى إدخال بريدك الإلكتروني',
      "kPleaseEnterYourPhone": 'يرجى إدخال رقم هاتفك',
      "kCarNumber": "رقم السيارة",
      'kPackName': 'اسم الباقة ',

      "kRemainingWash": "الغسلات المتبقية",
      "kRemaining": "المتبقي",
      'kExpiryDate': 'تاريخ انتهاء الصلاحية ',
      "kUpgradeYourPlanNow": "قم بترقية خطتك الآن",
      "kNoPlansAvailable": "لا توجد خطط متاحة",
      "kYouCanRenewYourSubscriptionOnlyWithin7DaysOfExpiry":
          "يمكنك تجديد اشتراكك فقط خلال 7 أيام من انتهاء الصلاحية.",
      "kRenewNow": "جدد الآن",
      "kYear": "/ السنة",
      "kRenewalNotAvailable": "التجديد غير متاح",
      "kNoPlanSelected": "لم يتم اختيار خطة.",
      'kEmployeeIDNO': 'رقم هوية الموظف: ',
      "kAddress": "العنوان",
      "kPermissionDenied": "تم رفض الإذن",
      "kCameraPermissionRequired":
          "إذن الكاميرا مطلوب لمسح رموز الاستجابة السريعة.",

      /// QR screen
      "kClear": "مسح",
      "kScanAQRCode": 'امسح رمز الاستجابة السريعة',
      "kCustomerID": "معرف العميل: ",
      "kRewardID": "معرف المكافأة:",
      "kRewardScreen": "شاشة المكافآت",
      "kPleaseCaptureAnImage": "يرجى التقاط صورة.",

      ///Today Screen
      "kReward": "مكافأة",
      "kScanOffer": "مسح العرض",
      "kCaptureCarNumber": "التقط لوحة أرقام السيارة\nوتحقق منها",
      "kSwipeToCompleteWash": "اسحب لإكمال الغسيل ",
      "kErrorCompletingWash": "خطأ في إكمال الغسيل:",
      "kWashComplete": "اكتمل الغسيل!",
      "kShareYourFeedback": "شارك رأيك وقيم\nالعميل.",
      "kEnterYourCommentHere": "أدخل تعليقك هنا...",
      "kSubmit": "إرسال",
      "kTodayWashes": "غسلات اليوم",
      "kComplete": "مكتمل",

      /// app component
      'kRemainingWashes': 'الغسلات المتبقية: ',
      "kDateIsNotFound": 'البيانات غير موجودة',
      "kOfferDetails": "تفاصيل العرض",
      "kHowToRedeem": "كيفية الاستبدال",
      "kReportAnIssue": "الإبلاغ عن مشكلة",
      "kYourRewardHasBeen": "تم استبدال مكافأتك\nبنجاح!",
      "kDay": "يوم",
      "kHRS": "ساعة",
      "kMINS": "دقيقة",
      "kQrNotGenerated": "لم يتم إنشاء\nرمز الاستجابة السريعة",
      "kSuccesss": "نجح!",
      "kPlanIsNowActivated": " تم تفعيل الخطة الآن.",
      "kScanToUnlockWeekly":
          "امسح لإلغاء قفل الغسلات الأسبوعية،\nالعروض الحصرية، والصفقات المذهلة!",
      "kYourPaymentIsComplete": "تمت عملية الدفع، و\n",
      "kJan": "يناير",
      "kFev": "فبراير",
      "kMar": "مارس",
      "kApr": "أبريل",
      "kMay": "مايو",
      "kJun": "يونيو",
      "kJul": "يوليو",
      "kAug": "أغسطس",
      "kSep": "سبتمبر",
      "kAct": "أكتوبر",
      "kNov": "نوفمبر",
      "kDec": "ديسمبر",
    },*/
  };
}
