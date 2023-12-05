class DocumentModel {
  String? success;
  String? error;
  String? message;
  List<DocumentData>? documentList;

  DocumentModel({this.success, this.error, this.message, this.documentList});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      documentList = <DocumentData>[];
      json['data'].forEach((v) {
        documentList!.add(DocumentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (documentList != null) {
      data['data'] = documentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocumentData {
  int? id;
  String? title;
  String? isEnabled;
  String? createdAt;
  String? updatedAt;

  DocumentData({this.id, this.title, this.isEnabled, this.createdAt, this.updatedAt});

  DocumentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']??"";
    isEnabled = json['is_enabled']??"";
    createdAt = json['created_at']??"";
    updatedAt = json['updated_at']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['is_enabled'] = isEnabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
