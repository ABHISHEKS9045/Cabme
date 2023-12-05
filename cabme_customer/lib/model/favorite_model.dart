class FavoriteModel {
  String? success;
  String? error;
  String? message;
  List<Data>? data;

  FavoriteModel({this.success, this.error, this.message, this.data});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  String? libelle;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? departName;
  String? destinationName;
  int? distance;
  String? statut;
  String? creer;
  String? modifier;
  String? distanceUnit;
  int? idUserApp;

  Data({
    this.id,
    this.libelle,
    this.latitudeDepart,
    this.longitudeDepart,
    this.latitudeArrivee,
    this.longitudeArrivee,
    this.departName,
    this.destinationName,
    this.distance,
    this.statut,
    this.creer,
    this.modifier,
    this.idUserApp,
    this.distanceUnit,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    distance = json['distance'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
    idUserApp = json['id_user_app'];
    distanceUnit = json['distance_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['distance'] = distance;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['id_user_app'] = idUserApp;
    data['distance_unit'] = distanceUnit;
    return data;
  }
}
