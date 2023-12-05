class DriverModel {
  String? success;
  String? error;
  String? message;
  List<Data>? data;

  DriverModel({this.success, this.error, this.message, this.data});

  DriverModel.fromJson(Map<String, dynamic> json) {
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
  String? nom;
  String? prenom;
  String? phone;
  String? email;
  String? online;
  String? photo;
  String? latitude;
  String? longitude;
  int? idVehicule;
  String? brand;
  String? model;
  String? color;
  String? numberplate;
  int? passenger;
  int? totalCompletedRide;
  String? typeVehicule;
  double? distance;
  double? moyenne;

  Data(
      {this.id,
      this.nom,
      this.prenom,
      this.phone,
      this.email,
      this.online,
      this.photo,
      this.latitude,
      this.longitude,
      this.idVehicule,
      this.brand,
      this.model,
      this.color,
      this.numberplate,
      this.passenger,
      this.typeVehicule,
      this.totalCompletedRide,
      this.distance,
      this.moyenne});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'] ?? '';
    prenom = json['prenom'] ?? '';
    phone = json['phone'];
    email = json['email'];
    online = json['online'];
    photo = json['photo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    idVehicule = json['idVehicule'];
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    numberplate = json['numberplate'];
    passenger = json['passenger'];
    typeVehicule = json['typeVehicule'];
    distance = double.parse(json['distance'].toString());
    totalCompletedRide = json['total_completed_ride'];
    moyenne = double.parse(json['moyenne'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['phone'] = phone;
    data['email'] = email;
    data['online'] = online;
    data['photo'] = photo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['idVehicule'] = idVehicule;
    data['brand'] = brand;
    data['model'] = model;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['typeVehicule'] = typeVehicule;
    data['distance'] = distance;
    data['moyenne'] = moyenne;
    data['total_completed_ride'] = totalCompletedRide;
    return data;
  }
}
