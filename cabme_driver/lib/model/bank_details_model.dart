class BankDetailsModel {
  String? success;
  String? error;
  String? message;
  BankData? data;

  BankDetailsModel({this.success, this.error, this.message, this.data});

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? BankData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BankData {
  String? bankName;
  String? branchName;
  String? holderName;
  String? accountNo;
  String? otherInfo;
  String? ifscCode;

  BankData({
    this.bankName,
    this.branchName,
    this.holderName,
    this.accountNo,
    this.otherInfo,
    this.ifscCode,
  });

  BankData.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    otherInfo = json['other_info'];
    ifscCode = json['ifsc_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['other_info'] = otherInfo;
    data['ifsc_code'] = ifscCode;
    return data;
  }
}
