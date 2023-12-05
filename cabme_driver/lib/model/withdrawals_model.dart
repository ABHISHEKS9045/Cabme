class WithdrawalsModel {
  String? success;
  String? error;
  String? message;
  List<WithdrawalsData>? data;

  WithdrawalsModel({this.success, this.error, this.message, this.data});

  WithdrawalsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WithdrawalsData>[];
      json['data'].forEach((v) {
        data!.add(WithdrawalsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WithdrawalsData {
  int? id;
  int? idConducteur;
  String? amount;
  String? note;
  String? statut;
  String? creer;
  String? createdAt;
  String? modifier;
  String? updatedAt;
  String? bankName;
  String? branchName;
  String? accountNo;
  String? otherInfo;
  String? ifscCode;

  WithdrawalsData(
      {this.id,
        this.idConducteur,
        this.amount,
        this.note,
        this.statut,
        this.creer,
        this.createdAt,
        this.modifier,
        this.updatedAt,
        this.bankName,
        this.branchName,
        this.accountNo,
        this.otherInfo,
        this.ifscCode});

  WithdrawalsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idConducteur = json['id_conducteur'];
    amount = json['amount'];
    note = json['note'];
    statut = json['statut'];
    creer = json['creer'];
    createdAt = json['created_at'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    accountNo = json['account_no'];
    otherInfo = json['other_info'];
    ifscCode = json['ifsc_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_conducteur'] = idConducteur;
    data['amount'] = amount;
    data['note'] = note;
    data['statut'] = statut;
    data['creer'] = creer;
    data['created_at'] = createdAt;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['account_no'] = accountNo;
    data['other_info'] = otherInfo;
    data['ifsc_code'] = ifscCode;
    return data;
  }
}
