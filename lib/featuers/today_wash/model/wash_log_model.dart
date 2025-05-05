class WashLogModel {
  bool? success;
  String? message;
  List<Data>? data;

  WashLogModel({this.success, this.message, this.data});

  WashLogModel.fromJson(Map<String, dynamic> json) {
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
  String? customerName;
  String? redeemedAt;
  Null? profilePicUrl;
  int? rating;
  bool? isPremium;

  Data(
      {this.id,
        this.customerName,
        this.redeemedAt,
        this.profilePicUrl,
        this.rating,
        this.isPremium});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    redeemedAt = json['redeemedAt'];
    profilePicUrl = json['profilePicUrl'];
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
