import '../../../network_manager/api_constant.dart';

class GetWorkerModel {
  bool? success;
  String? message;
  List<Data>? data;

  GetWorkerModel({this.success, this.message, this.data});

  GetWorkerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

  Data({
    this.id,
    this.employeeId,
    this.fullName,
    this.locationId,
    this.mobileNumber,
    this.email,
    this.address,
    this.profilePicUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    fullName = json['fullName'];
    locationId = json['locationId'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    address = json['address'];
    profilePicUrl =
        json['profilePicUrl'] != null
            ? "${ApiConstant.baseImageUrl}${json['profilePicUrl']}"
            : null;
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
    return data;
  }
}
