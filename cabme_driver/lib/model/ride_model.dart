// ignore_for_file: non_constant_identifier_names

class RideModel {
  String? success;
  String? error;
  String? message;
  List<RideData>? rideData;

  RideModel({this.success, this.error, this.message, this.rideData});

  RideModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      rideData = <RideData>[];
      json['data'].forEach((v) {
        rideData!.add(RideData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (rideData != null) {
      data['data'] = rideData!.map((v) => v.toJson()).toList();
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
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  int? numberPoeple;
  String? place;
  String? statut;
  int? idConducteur;
  String? creer;
  String? trajet;
  int? feelSafeDriver;
  String? nom;
  String? prenom;
  int? distance;
  String? phone;
  String? photoPath;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  double? montant;
  String? duree;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  int? carDriverConfirmed;
  String? driver_phone;
  double? moyenne;
  double? moyenneDriver;
  String? comment;
  String? commentDriver;
  String? distanceUnit;
  double? discount;
  double? tipAmount;
  double? tax;

  RideData({
    this.id,
    this.idUserApp,
    this.departName,
    this.destinationName,
    this.latitudeDepart,
    this.longitudeDepart,
    this.latitudeArrivee,
    this.longitudeArrivee,
    this.dateRetour,
    this.heureRetour,
    this.statutRound,
    this.numberPoeple,
    this.place,
    this.statut,
    this.idConducteur,
    this.creer,
    this.trajet,
    this.feelSafeDriver,
    this.nom,
    this.prenom,
    this.distance,
    this.phone,
    this.photoPath,
    this.nomConducteur,
    this.prenomConducteur,
    this.driverPhone,
    this.montant,
    this.duree,
    this.statutPaiement,
    this.payment,
    this.paymentImage,
    this.carDriverConfirmed,
    this.driver_phone,
    this.moyenne,
    this.moyenneDriver,
    this.comment,
    this.commentDriver,
    this.distanceUnit,
    this.discount,
    this.tipAmount,
    this.tax,
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
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    numberPoeple = json['number_poeple'];
    place = json['place'];
    statut = json['statut'];
    idConducteur = json['id_conducteur'];
    creer = json['creer'];
    trajet = json['trajet'];
    feelSafeDriver = json['feel_safe_driver'];
    nom = json['nom'] ?? '';
    prenom = json['prenom'] ?? '';
    distance = json['distance'];
    phone = json['phone'];
    photoPath = json['photo_path'];
    nomConducteur = json['nomConducteur'] ?? '';
    prenomConducteur = json['prenomConducteur'] ?? '';
    driverPhone = json['driverPhone'];
    montant = double.parse(json['montant'].toString());
    duree = json['duree'];
    statutPaiement = json['statut_paiement'];
    payment = json['payment'];
    paymentImage = json['payment_image'];
    carDriverConfirmed = json['car_driver_confirmed'];
    driver_phone = json['driver_phone'];
    moyenne = double.parse(json['moyenne'].toString());
    moyenneDriver = double.parse(json['moyenne_driver'].toString());
    comment = json['comment'];
    commentDriver = json['comment_driver'];
    distanceUnit = json['distance_unit'];
    discount = json['discount'] != null?double.parse(json['discount'].toString()):0.0;
    tipAmount = json['tip_amount'] != null?double.parse(json['tip_amount'].toString()):0.0;
    tax = json['tax'] != null?double.parse(json['tax'].toString()):0.0;
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
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['number_poeple'] = numberPoeple;
    data['place'] = place;
    data['statut'] = statut;
    data['id_conducteur'] = idConducteur;
    data['creer'] = creer;
    data['trajet'] = trajet;
    data['feel_safe_driver'] = feelSafeDriver;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['distance'] = distance;
    data['phone'] = phone;
    data['photo_path'] = photoPath;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['montant'] = montant;
    data['duree'] = duree;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['car_driver_confirmed'] = carDriverConfirmed;
    data['driver_phone'] = driver_phone;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['comment'] = comment;
    data['comment_driver'] = commentDriver;
    data['distance_unit'] = distanceUnit;
    data['discount'] = discount;
    data['tip_amount'] = tipAmount;
    data['tax'] = tax;
    return data;
  }
}
