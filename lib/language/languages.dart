import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      "kWelcomeToThe": "Welcome to the",
      "kHiWASH":"HI WASH",
      "kWeComeToYouTo":"We come to you to\nwash your car...!!",

      ///  welcome screen
      "kEliteCarWash":  "Elite car wash service",
      "kEarnMoreGetRewardsAndEnjoyExclusiveWorkerBenefits":"Earn more, get rewards, and enjoy\nexclusive worker benefits!",
      "kGetStarted": "Get Started",
      "kSkip": "Skip",
      "kTermsAndConditions": "Terms & Conditions",
      "kTermsAndCondition": "Terms & Condition",
      "kWashWin": "Wash & Win!",
      "kGetYourCarWashed":
          "Get your car washed weekly at 100+ locations with exclusive offers.Missed washes still deducted.",
      "kMissedWashesStillDeducted": "Missed washes still deducted.",
      "kLetMakeEvery":"Let's Make Every Car Shine!",

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
      "kPLeaseEnterValid":"Please Enter A Valid Email",
      "kPhoneNumberCannotBeEmpty":"Phone number cannot be empty",



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
      "kTestOTP":"TEST OTP: ",


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
      "kRewardedCustomers":"Rewarded Customers",
      "kToday":"Today",
      "kWashLog":"Wash Log",

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
      "UserGrantedPermission":"User granted permission",


      /// Profile Screen
      "kProfileUpdatedSuccessfully": 'Profile updated successfully',
      "kPackExpiringIn": ' pack\nexpiring in ',
      "kMyAccount": 'My Account',
      "kSubscriptionPlan": 'Subscription Plan',
      "kTheme": 'Theme',
      "kLanguage": 'Language',
      "kPrivacySettings": 'Privacy Settings',
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
      "kRemaining":"kRemaining",
      'kExpiryDate': 'Expiry date ',
      "kUpgradeYourPlanNow": "upgrade your Plan now",
      "kNoPlansAvailable": "No plans available",
      "kYouCanRenewYourSubscriptionOnlyWithin7DaysOfExpiry":
      "You can renew your subscription only within 7 days of expiry.",
      "kRenewNow": "Renew Now",
      "kYear": "/ Year",
      "kRenewalNotAvailable": "Renewal Not Available",
      "kNoPlanSelected.": "No plan selected.",
      'kEmployeeIDNO: ':'Employee ID NO: ',
      "kAddress":"Address",
      "kPermissionDenied":"Permission Denied",
      "kCameraPermissionRequired":"Camera permission is required to scan QR codes.",
      /// QR screen
      "kClear":"Clear",
      "kScanAQRCode":'Scan a QR code',
      "kCustomerID:":"Customer ID: ",
      "kRewardID":"Reward ID:",
      "kRewardScreen":"Reward Screen",
      "kPleaseCaptureAnImage":"Please capture an image.",

      ///Today Screen
      "kReward":"Reward",
      "kScanOffer":"Scan Offer",
      "kCaptureCarNumber":"Capture Car Number Plate\nAnd Verify",
      "kSwipeToCompleteWash": "Swipe to Complete Wash ",
      "kErrorCompletingWash":"Error completing wash:",
      "kWashComplete":"Wash Complete!",
      "kShareYourFeedback":"Share your feedback and\nrate the Customer.",
      "kEnterYourCommentHere":"Enter your comment here...",
      "kSubmit":"Submit",
      "kTodayWashes":"kTodayWashes",
      "kComplete":"Complete",


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
      "kYourPaymentIsComplete":"Your payment is complete, and your\n"
    },

    'hi_IN': {
      "kEcoCleanWalletGreen": "इको क्लीन, वॉलेट ग्रीन!",
      "kExclusiveDealsWithEvery":
          "हर शाइन फ्री कूपन, BOGO ऑफर, छूट और विशेष सुविधाओं के साथ विशेष सौदे!",
      " kGetStarted": "शुरू हो जाओ",
    },
  };
}
