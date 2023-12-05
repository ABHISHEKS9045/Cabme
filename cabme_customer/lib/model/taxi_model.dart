class TaxiModel {
  List<TaxiData>? data;
  String? success;
  String? error;
  String? message;

  TaxiModel({this.data, this.success, this.error, this.message});

  TaxiModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TaxiData>[];
      json['data'].forEach((v) {
        data!.add(TaxiData.fromJson(v));
      });
    }
    success = json['success'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}

class TaxiData {
  int? id;
  String? brand;
  String? model;
  String? color;
  String? numberplate;
  String? statut;
  String? latitude;
  String? longitude;
  String? creer;
  String? modifier;
  int? idConducteur;
  String? nom;
  String? prenom;
  String? statutDriver;

  TaxiData(
      {this.id,
      this.brand,
      this.model,
      this.color,
      this.numberplate,
      this.statut,
      this.latitude,
      this.longitude,
      this.creer,
      this.modifier,
      this.idConducteur,
      this.nom,
      this.prenom,
      this.statutDriver});

  TaxiData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    numberplate = json['numberplate'];
    statut = json['statut'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    creer = json['creer'];
    modifier = json['modifier'];
    idConducteur = json['idConducteur'];
    nom = json['nom'];
    prenom = json['prenom'];
    statutDriver = json['statut_driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['statut'] = statut;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['idConducteur'] = idConducteur;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['statut_driver'] = statutDriver;
    return data;
  }
}
