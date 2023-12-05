class UploadedDocumentModel {
  String? success;
  String? error;
  String? message;
  List<UploadedDocumentData>? data;

  UploadedDocumentModel({this.success, this.error, this.message, this.data});

  UploadedDocumentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UploadedDocumentData>[];
      json['data'].forEach((v) {
        data!.add(UploadedDocumentData.fromJson(v));
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

class UploadedDocumentData {
  int? id;
  String? title;
  String? isEnabled;
  String? createdAt;
  String? updatedAt;
  String? documentPath;
  String? documentStatus;
  String? comment;
  String? documentName;

  UploadedDocumentData(
      {this.id,
        this.title,
        this.isEnabled,
        this.createdAt,
        this.updatedAt,
        this.documentPath,
        this.documentStatus,
        this.comment,
        this.documentName});

  UploadedDocumentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isEnabled = json['is_enabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    documentPath = json['document_path'];
    documentStatus = json['document_status'];
    comment = json['comment'];
    documentName = json['document_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['is_enabled'] = isEnabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['document_path'] = documentPath;
    data['document_status'] = documentStatus;
    data['comment'] = comment;
    data['document_name'] = documentName;
    return data;
  }
}
