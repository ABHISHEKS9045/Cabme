class RentVehicleModel {
  String? success;
  String? error;
  String? message;
  List<RentVehicleData>? data;

  RentVehicleModel({this.success, this.error, this.message, this.data});

  RentVehicleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RentVehicleData>[];
      json['data'].forEach((v) {
        data!.add(RentVehicleData.fromJson(v));
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

class RentVehicleData {
  int? id;
  String? libelle;
  String? prix;
  String? image;
  int? noOfPassenger;
  String? nombre;
  int? nbPlace;
  String? status;
  String? creer;
  String? modifier;
  String? createdAt;
  String? updatedAt;
  int? nbReserve;

  RentVehicleData(
      {this.id,
        this.libelle,
        this.prix,
        this.image,
        this.noOfPassenger,
        this.nombre,
        this.nbPlace,
        this.status,
        this.creer,
        this.modifier,
        this.createdAt,
        this.updatedAt,
        this.nbReserve});

  RentVehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    prix = json['prix'];
    image = json['image'];
    noOfPassenger = json['no_of_passenger'];
    nombre = json['nombre'];
    nbPlace = json['nb_place'];
    status = json['status'];
    creer = json['creer'];
    modifier = json['modifier'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nbReserve = json['nb_reserve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['prix'] = prix;
    data['image'] = image;
    data['no_of_passenger'] = noOfPassenger;
    data['nombre'] = nombre;
    data['nb_place'] = nbPlace;
    data['status'] = status;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['nb_reserve'] = nbReserve;
    return data;
  }
}
