import '../../../network_manager/api_constant.dart';

class TodayWashSummaryModel {
  bool? success;
  String? message;
  Data? data;

  TodayWashSummaryModel({this.success, this.message, this.data});

  TodayWashSummaryModel.fromJson(Map<String, dynamic> json) {
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
  Summary? summary;
  List<Washes>? washes;

  Data({this.summary, this.washes});

  Data.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['washes'] != null) {
      washes = <Washes>[];
      json['washes'].forEach((v) {
        washes!.add(new Washes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.washes != null) {
      data['washes'] = this.washes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? totalWashes;
  int? completed;
  int? remaining;

  Summary({this.totalWashes, this.completed, this.remaining});

  Summary.fromJson(Map<String, dynamic> json) {
    totalWashes = json['totalWashes'];
    completed = json['completed'];
    remaining = json['remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalWashes'] = this.totalWashes;
    data['completed'] = this.completed;
    data['remaining'] = this.remaining;
    return data;
  }
}

class Washes {
  int? id;
  String? customerName;
  String? redeemedAt;
  bool? isCompleted;
  String? profilePicUrl;
  int? rating;
  bool? isPremium;

  Washes({
    this.id,
    this.customerName,
    this.redeemedAt,
    this.isCompleted,
    this.profilePicUrl,
    this.rating,
    this.isPremium,
  });

  Washes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customerName'];
    redeemedAt = json['redeemedAt'];
    isCompleted = json['isCompleted'];
    profilePicUrl = json['profilePicUrl'] != null
        ? "${ApiConstant.baseImageUrl}${json['profilePicUrl']}"
        : null;
/*
    profilePicUrl =
        json['profilePicUrl'] != null
            ? "${ApiConstant.baseImageUrl}${json['profilePicUrl']}"
            : null;
*/

    rating = json['rating'];
    isPremium = json['isPremium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['customerName'] = this.customerName;
    data['redeemedAt'] = this.redeemedAt;
    data['isCompleted'] = this.isCompleted;
    data['profilePicUrl'] = this.profilePicUrl;
    data['rating'] = this.rating;
    data['isPremium'] = this.isPremium;
    return data;
  }
}
