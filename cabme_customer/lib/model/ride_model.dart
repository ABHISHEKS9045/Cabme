// ignore_for_file: non_constant_identifier_names

class RideModel {
  String? success;
  String? error;
  String? message;
  List<RideData>? data;

  RideModel({this.success, this.error, this.message, this.data});

  RideModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RideData>[];
      json['data'].forEach((v) {
        data!.add(RideData.fromJson(v));
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

class RideData {
  int? id;
  int? idUserApp;
  String? departName;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  int? numberPoeple;
  String? place;
  String? statut;
  int? idConducteur;
  String? creer;
  String? trajet;
  String? tripObjective;
  String? tripCategory;
  int? feelSafe;
  int? feelSafeDriver;
  String? nom;
  String? prenom;
  int? distance;
  String? phone;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? photoPath;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  double? montant;
  String? duree;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  String? driver_phone;
  double? moyenne;
  double? moyenneDriver;

  String? comment;
  String? commentDriver;
  String? brand;
  String? model;
  String? color;
  String? numberplate;
  String? otp;
  String? distanceUnit;

  RideData({
    this.id,
    this.idUserApp,
    this.departName,
    this.destinationName,
    this.latitudeDepart,
    this.longitudeDepart,
    this.latitudeArrivee,
    this.longitudeArrivee,
    this.numberPoeple,
    this.place,
    this.statut,
    this.idConducteur,
    this.creer,
    this.trajet,
    this.tripObjective,
    this.tripCategory,
    this.feelSafe,
    this.feelSafeDriver,
    this.nom,
    this.prenom,
    this.distance,
    this.phone,
    this.nomConducteur,
    this.prenomConducteur,
    this.driverPhone,
    this.photoPath,
    this.dateRetour,
    this.heureRetour,
    this.statutRound,
    this.montant,
    this.duree,
    this.statutPaiement,
    this.payment,
    this.paymentImage,
    this.driver_phone,
    this.moyenne,
    this.moyenneDriver,
    this.comment,
    this.brand,
    this.model,
    this.color,
    this.numberplate,
    this.commentDriver,
    this.otp,
    this.distanceUnit,
  });

  RideData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUserApp = json['id_user_app'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    numberPoeple = json['number_poeple'];
    place = json['place'];
    statut = json['statut'];
    idConducteur = json['id_conducteur'];
    creer = json['creer'];
    trajet = json['trajet'];
    tripObjective = json['trip_objective'];
    tripCategory = json['trip_category'];
    feelSafe = json['feel_safe'];
    feelSafeDriver = json['feel_safe_driver'];
    nom = json['nom'] ?? '';
    prenom = json['prenom'] ?? '';
    distance = json['distance'];
    phone = json['phone'];
    nomConducteur = json['nomConducteur'] ?? '';
    prenomConducteur = json['prenomConducteur'] ?? '';
    driverPhone = json['driverPhone'];
    photoPath = json['photo_path'];
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    montant = double.parse(json['montant'].toString());
    duree = json['duree'];
    statutPaiement = json['statut_paiement'];
    payment = json['payment'];
    paymentImage = json['payment_image'];
    driver_phone = json['driver_phone'];
    moyenne = double.parse(json['moyenne'].toString());
    moyenneDriver = double.parse(json['moyenne_driver'].toString());
    comment = json['comment'];
    commentDriver = json['comment_driver'];
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    numberplate = json['numberplate'];
    otp = json['otp'].toString();
    distanceUnit = json['distance_unit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['number_poeple'] = numberPoeple;
    data['place'] = place;
    data['statut'] = statut;
    data['id_conducteur'] = idConducteur;
    data['creer'] = creer;
    data['trajet'] = trajet;
    data['trip_objective'] = tripObjective;
    data['trip_category'] = tripCategory;
    data['feel_safe'] = feelSafe;
    data['feel_safe_driver'] = feelSafeDriver;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['distance'] = distance;
    data['phone'] = phone;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['photo_path'] = photoPath;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['montant'] = montant;
    data['duree'] = duree;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['driver_phone'] = driver_phone;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['comment'] = comment;
    data['comment_driver'] = commentDriver;
    data['brand'] = brand;
    data['model'] = model;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['otp'] = otp;
    data['distance_unit'] = distanceUnit;
    return data;
  }
}
