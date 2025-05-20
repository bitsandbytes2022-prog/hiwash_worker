import 'package:dio/dio.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';
import 'package:hiwash_worker/network_manager/utils/api_response.dart';

import '../featuers/auth/model/get_token_model.dart';
import '../featuers/auth/model/send_otp_model.dart';
import '../featuers/auth/model/sign_up_model.dart';
import '../featuers/dashboard/model/get_customer_data_model.dart';
import '../featuers/dashboard/model/get_worker_model.dart';

import '../featuers/dashboard/view/widget/second_drawer/model/faq_response_model.dart';
import '../featuers/dashboard/view/widget/second_drawer/model/guides_response_model.dart';
import '../featuers/notification/model/notification.dart';
import '../featuers/profile/model/terms_and_conditions_response_model.dart';
import '../featuers/qr_scanner/model/get_offers_by_id_model.dart';
import '../featuers/today_wash/model/wash_log_model.dart';
import 'api_constant.dart';
import 'dio_helper.dart';
import 'local_storage.dart';

class Repository {
  final DioHelper dioHelper = DioHelper();
  final LocalStorage localStorage = LocalStorage();

  Future<SendOtpModel> sendOtpRepo(Object requestBody) async {
    print(" sendOtp body--->: $requestBody");
    print(" sendOtp url--->: ${ApiConstant.sendOtp}");

    var response = await dioHelper.post(
      url: ApiConstant.sendOtp,
      requestBody: requestBody,
    );
    print("SendOtp Response--->: $response");
    return SendOtpModel.fromJson(response);
  }

  Future<GetTokenModel> getTokens(Object requestBody) async {
    print("body--->: $requestBody");
    print("url--->: ${ApiConstant.getToken}");

    var response = await dioHelper.post(
      url: ApiConstant.getToken,
      requestBody: requestBody,
    );
    print("Response--->: $response");

    return GetTokenModel.fromJson(response);
  }

  Future<GetWorkerModel> getWorkerData(int id) async {
    print(" GetWorkerModel url--->:${ApiConstant.getWorkerId(id)}");
    var response = await dioHelper.get(
      url: ApiConstant.getWorkerId(id),
      isAuthRequired: true,
    );
    print("---->GetWorkerModel--->${response.toString()}");

    return GetWorkerModel.fromJson(response);
  }



  Future<GetCustomerData> getCustomerData(int id) async {
    print("url dss--->:${ApiConstant.getCustomerId(id)}");
    var response = await dioHelper.get(
      url: ApiConstant.getCustomerId(id),
      isAuthRequired: true,
    );
    print("getCustomerData--->${response.toString()}");

    return GetCustomerData.fromJson(response);
  }


  Future<FaqResponseModel> getFaq(int entityType) async {
    Map<String, dynamic> response = await dioHelper.get(
      url: ApiConstant.baseUrl + ApiConstant.getFaq(entityType),
      isAuthRequired: true,
    );
    return FaqResponseModel.fromJson(response);
  }

  Future<GuidesResponseModel> getGuides(int entityType) async {
    var response = await dioHelper.get(
      url: ApiConstant.baseUrl + ApiConstant.getGuides(entityType),
      isAuthRequired: true,
    );

    return GuidesResponseModel.fromJson(response);
  }

  Future<TermsAndConditionsResponseModel> getTermsAndConditions(
    int entityType,
  ) async {
    Map<String, dynamic> response = await dioHelper.get(
      url: ApiConstant.baseUrl + ApiConstant.getTermsAndConditions(entityType),
      isAuthRequired: true,
    );
    print("---->termcondition${response.toString()}");
    return TermsAndConditionsResponseModel.fromJson(response);
  }

  Future<dynamic> uploadProfilePicture(requestBody) async {
    try {
      final response = await dioHelper.post(
        url: ApiConstant.uploadProfileImage,
        requestBody: requestBody,
        isAuthRequired: true,
      );
      print("Upload success: $response");

      return response;
    } catch (e) {
      print("Upload failed: $e");
    }
  }

  Future<dynamic> uploadProfile(Object requestBody) async {
    try {
      final response = await dioHelper.put(
        url: ApiConstant.uploadProfile,
        requestBody: requestBody,
        isAuthRequired: true,
      );
      print("Save profile success: $response");
    } catch (e) {
      print("Save profile failed: $e");
    }
  }

  Future<dynamic> validateWashQrRepo(Object requestBody) async {
    try {
      final response = await dioHelper.post(
        url: ApiConstant.validateWashQr,
        requestBody: requestBody,
        isAuthRequired: true,
      );
      print("validateWashQr success: $response");
    } catch (e) {
      print("validateWashQr failed: $e");
    }
  }

  Future<TodayWashSummaryModel> todayWashSummaryRepo() async {
    var response = await dioHelper.get(
      url: ApiConstant.todayWashSummary,
      isAuthRequired: true,
    );

    return TodayWashSummaryModel.fromJson(response);
  }


  Future<void> completeWashRepo(requestBody) async {
    try {
      final response = await dioHelper.post(
        url: ApiConstant.completeWash,
        requestBody: requestBody,
        isAuthRequired: true,
      );
      print("Upload response: ${response.toString()}");
    } catch (e) {
      print("Upload complete success: $e");
    } catch (e) {
      print("Upload complete failed: $e");
    }
  }
  Future<WashLogModel> washLogRepo(Object requestBody) async {
    Map<String, dynamic> response = await dioHelper.post(
      requestBody: requestBody,
      url: ApiConstant.washLog,
      isAuthRequired: true,
    );
    print("---->${response.toString()}");
    return WashLogModel.fromJson(response);
  }

  Future<GetOffersByIdModel> getOfferById(int id) async {
    // print("url--->:${ApiConstant.getOffersById}");
    Map<String, dynamic> response = await dioHelper.get(
      url: ApiConstant.getOffersById(id),
      isAuthRequired: true,
    );
    print("Response--->: $response");
    return GetOffersByIdModel.fromJson(response);
  }

  Future<dynamic> validateOfferQrRepo(Object requestBody) async {
    try {
      final response = await dioHelper.post(
        url: ApiConstant.validateOfferQr,
        requestBody: requestBody,
        isAuthRequired: true,
      );

      print("validateOfferQr success: $response");
      return response;
    } catch (e) {
      print("validateOfferQr failed: $e");
    }
  }

  Future<ApiResponse> rating(Object requestBody) async {
    // print("Rating body--->: $requestBody");
    Map<String, dynamic> response = await dioHelper.post(
      url: ApiConstant.rating,
      requestBody: requestBody,
      isAuthRequired: true,
    );
    //  print("Rating Response--->: $response");
    return ApiResponse.fromJson(response);
  }



  Future<dynamic> getNotificationRepo(Object requestBody) async {
    Map<String, dynamic> response = await dioHelper.post(
      url: ApiConstant.notificationUrl,
      isAuthRequired: true,
      requestBody: requestBody,
    );

    return response;
  }

}
