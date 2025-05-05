import 'package:hiwash_worker/network_manager/api_constant.dart';

class GetTokenModel {
  bool? success;
  String? message;
  Data? data;

  GetTokenModel({this.success, this.message, this.data});

  GetTokenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? employeeId;
  String? fullName;
  int? locationId;
  String? mobileNumber;
  String? email;
  String? address;
  String? profilePicUrl;
  String? token;

  Data(
      {this.id,
        this.employeeId,
        this.fullName,
        this.locationId,
        this.mobileNumber,
        this.email,
        this.address,
        this.profilePicUrl,
        this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    fullName = json['fullName'];
    locationId = json['locationId'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    address = json['address'];
    profilePicUrl = json['profilePicUrl']!=null?"${ApiConstant.baseImageUrl}${json['profilePicUrl']}":null;

    /* profilePicUrl =
        json['profilePicUrl'] != null
            ? "${ApiConstant.baseImageUrl}${json['profilePicUrl']}"
            : null;
*/

    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['fullName'] = this.fullName;
    data['locationId'] = this.locationId;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['profilePicUrl'] = this.profilePicUrl;
    data['token'] = this.token;
    return data;
  }
}
