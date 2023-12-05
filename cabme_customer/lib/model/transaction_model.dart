class TransactionModel {
  String? success;
  String? error;
  String? message;
  List<TransactionData>? transactionData;

  TransactionModel({this.success, this.error, this.message, this.transactionData});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      transactionData = <TransactionData>[];
      json['data'].forEach((v) {
        transactionData!.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (transactionData != null) {
      data['data'] = transactionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionData {
  int? id;
  double? amount;
  int? idUserApp;
  int? deductionType;
  int? rideId;
  String? paymentMethod;
  String? creer;
  String? modifier;

  TransactionData({this.id, this.amount, this.idUserApp, this.deductionType, this.rideId, this.paymentMethod, this.creer, this.modifier});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = double.parse(json['amount'].toString());
    idUserApp = json['id_user_app'];
    deductionType = json['deduction_type'];
    rideId = json['ride_id'];
    paymentMethod = json['payment_method'];
    creer = json['creer'];
    modifier = json['modifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['id_user_app'] = idUserApp;
    data['deduction_type'] = deductionType;
    data['ride_id'] = rideId;
    data['payment_method'] = paymentMethod;
    data['creer'] = creer;
    data['modifier'] = modifier;
    return data;
  }
}
