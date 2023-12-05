class VehicleCategoryModel {
  String? success;
  String? error;
  String? message;
  List<VehicleData>? vehicleData;

  VehicleCategoryModel({this.success, this.error, this.message, this.vehicleData});

  VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'] ?? '';
    message = json['message'];
    if (json['data'] != null) {
      vehicleData = <VehicleData>[];
      json['data'].forEach((v) {
        vehicleData!.add(VehicleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (vehicleData != null) {
      data['data'] = vehicleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleData {
  int? id;
  String? libelle;
  String? prix;
  String? image;
  String? selectedImage;
  String? creer;
  String? modifier;
  String? updatedAt;
  String? deletedAt;
  String? imagePath;
  String? selectedImagePath;
  String? statutCommission;
  String? commission;
  String? type;
  String? statutCommissionPerc;
  String? commissionPerc;
  String? typePerc;

  VehicleData(
      {this.id,
        this.libelle,
        this.prix,
        this.image,
        this.selectedImage,
        this.creer,
        this.modifier,
        this.updatedAt,
        this.deletedAt,
        this.imagePath,
        this.selectedImagePath,
        this.statutCommission,
        this.commission,
        this.type,
        this.statutCommissionPerc,
        this.commissionPerc,
        this.typePerc});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    prix = json['prix'];
    image = json['image'];
    selectedImage = json['selected_image'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imagePath = json['image_path'];
    selectedImagePath = json['selected_image_path'];
    statutCommission = json['statut_commission'];
    commission = json['commission'];
    type = json['type'];
    statutCommissionPerc = json['statut_commission_perc'];
    commissionPerc = json['commission_perc'];
    typePerc = json['type_perc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['prix'] = prix;
    data['image'] = image;
    data['selected_image'] = selectedImage;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['image_path'] = imagePath;
    data['selected_image_path'] = selectedImagePath;
    data['statut_commission'] = statutCommission;
    data['commission'] = commission;
    data['type'] = type;
    data['statut_commission_perc'] = statutCommissionPerc;
    data['commission_perc'] = commissionPerc;
    data['type_perc'] = typePerc;
    return data;
  }
}
