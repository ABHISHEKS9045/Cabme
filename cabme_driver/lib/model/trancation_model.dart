class TruncationModel {
  String? success;
  String? error;
  String? message;
  List<Data>? data;
  String? totalEarnings;

  TruncationModel(
      {this.success,
        this.error,
        this.message,
        this.data,
        this.totalEarnings});

  TruncationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    totalEarnings = json['total_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_earnings'] = totalEarnings;
    return data;
  }
}

class Data {
  int? id;
  String? amount;
  String? adminCommission;
  String? tax;
  String? tipAmount;
  String? discount;
  int? idUserApp;
  String? departName;
  String? destinationName;
  String? creer;
  int? idPaymentMethod;
  String? libelle;
  String? userName;
  String? userPhoto;
  String? userPhotoPath;

  Data(
      {this.id,
        this.amount,
        this.adminCommission,
        this.tax,
        this.tipAmount,
        this.discount,
        this.idUserApp,
        this.departName,
        this.destinationName,
        this.creer,
        this.idPaymentMethod,
        this.libelle,
        this.userName,
        this.userPhoto,
        this.userPhotoPath});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    adminCommission = json['admin_commission'];
    tax =json['tax'].toString();
    tipAmount = json['tip_amount'];
    discount =  json['discount'];
    idUserApp = json['id_user_app'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    creer = json['creer'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
    userName = json['user_name'];
    userPhoto = json['user_photo'];
    userPhotoPath = json['user_photo_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['admin_commission'] = adminCommission;
    data['tax'] = tax;
    data['tip_amount'] = tipAmount;
    data['discount'] = discount;
    data['id_user_app'] = idUserApp;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['creer'] = creer;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    data['user_name'] = userName;
    data['user_photo'] = userPhoto;
    data['user_photo_path'] = userPhotoPath;
    return data;
  }
}
