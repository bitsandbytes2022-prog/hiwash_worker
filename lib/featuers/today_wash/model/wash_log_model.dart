import 'package:hiwash_worker/network_manager/api_constant.dart';

class WashLogModel {
  bool? success;
  String? message;
  List<WashLogData>? data;

  WashLogModel({this.success, this.message, this.data});

  WashLogModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WashLogData>[];
      json['data'].forEach((v) {
        data!.add(new WashLogData.fromJson(v));
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

class WashLogData {
  int? id;
  String? customerName;
  String? redeemedAt;
  String? profilePicUrl;
  int? rating;
  bool? isPremium;

  WashLogData(
      {this.id,
        this.customerName,
        this.redeemedAt,
        this.profilePicUrl,
        this.rating,
        this.isPremium});

  WashLogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    redeemedAt = json['redeemedAt'];
    //profilePicUrl = json['profilePicUrl']!=null;
    profilePicUrl = json['profilePicUrl']!=null?"${ApiConstant.baseImageUrl}${json['profilePicUrl']}":null;

    rating = json['rating'];
    isPremium = json['isPremium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerName'] = this.customerName;
    data['redeemedAt'] = this.redeemedAt;
    data['profilePicUrl'] = this.profilePicUrl;
    data['rating'] = this.rating;
    data['isPremium'] = this.isPremium;
    return data;
  }
}
