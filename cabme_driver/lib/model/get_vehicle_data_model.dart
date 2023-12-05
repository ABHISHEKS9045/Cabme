class GetVehicleDataModel {
  String? success;
  String? error;
  String? message;
  VehicleData? vehicleData;

  GetVehicleDataModel({this.success, this.error, this.message, this.vehicleData});

  GetVehicleDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    vehicleData = json['data'] != null ? VehicleData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (vehicleData != null) {
      data['data'] = vehicleData!.toJson();
    }
    return data;
  }
}

class VehicleData {
  int? id;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  int? passenger;
  int? idConducteur;
  String? statut;
  String? creer;
  String? modifier;
  String? updatedAt;
  String? deletedAt;
  String? idTypeVehicule;

  VehicleData(
      {this.id,
      this.brand,
      this.model,
      this.carMake,
      this.milage,
      this.km,
      this.color,
      this.numberplate,
      this.passenger,
      this.idConducteur,
      this.statut,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.deletedAt,
      this.idTypeVehicule});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'].toString();
    model = json['model'].toString();
    carMake = json['car_make'];
    milage = json['milage'];
    km = json['km'];
    color = json['color'];
    numberplate = json['numberplate'];
    passenger = json['passenger'];
    idConducteur = json['id_conducteur'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    idTypeVehicule = json['id_type_vehicule'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['id_conducteur'] = idConducteur;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['id_type_vehicule'] = idTypeVehicule;
    return data;
  }
}
