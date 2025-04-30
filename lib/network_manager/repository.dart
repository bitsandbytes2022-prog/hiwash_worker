import 'package:dio/dio.dart';
import 'package:hiwash_worker/featuers/today_wash/model/today_wash_summary_model.dart';

import '../featuers/auth/model/get_token_model.dart';
import '../featuers/auth/model/send_otp_model.dart';
import '../featuers/auth/model/sign_up_model.dart';
import '../featuers/dashboard/model/get_customer_data_model.dart';
import '../featuers/dashboard/model/get_worker_model.dart';

import '../featuers/dashboard/view/widget/second_drawer/model/faq_response_model.dart';
import '../featuers/dashboard/view/widget/second_drawer/model/guides_response_model.dart';
import '../featuers/profile/model/terms_and_conditions_response_model.dart';
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
    print(" GetWorkerModel url--->:${ApiConstant.getCustomerId(id)}");
    var response = await dioHelper.get(
      url: ApiConstant.getCustomerId(id),
      isAuthRequired: true,
    );
    print("---->GetWorkerModel--->${response.toString()}");

    return GetWorkerModel.fromJson(response);
  }



/*  Future<GetCustomerData> getCustomerData(int id) async {
    print("url dss--->:${ApiConstant.getCustomerId(id)}");
    var response = await dioHelper.get(
      url: ApiConstant.getCustomerId(id),
      isAuthRequired: true,
    );
    print("getCustomerData--->${response.toString()}");

    return GetCustomerData.fromJson(response);
  }*/
  Future<GetCustomerData> getCustomerData(int id ) async {
    print("url dss--->:${ApiConstant.getCustomerId(id)}");

    final dio = Dio();
String? local=LocalStorage().getScannedQrCode();
    final String? accessToken = local;
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    try {
      var response = await dio.get(ApiConstant.getCustomerId(id));
      print("getCustomerData--->${response.toString()}");

      return GetCustomerData.fromJson(response.data);
    } catch (e) {
      print("Error fetching customer data: $e");
      rethrow;
    }
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

  Future<void> uploadProfilePicture(requestBody) async {
    try {
      final response = await dioHelper.post(
        url: ApiConstant.uploadProfileImage,
        requestBody: requestBody,
        isAuthRequired: true,
      );
      print("Upload success: $response");
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
}
