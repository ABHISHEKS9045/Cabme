class RideDetailsModel {
  String? success;
  String? error;
  String? message;
  RideDetailsdata? rideDetailsdata;

  RideDetailsModel(
      {this.success, this.error, this.message, this.rideDetailsdata});

  RideDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    rideDetailsdata =
        json['data'] != null ? RideDetailsdata.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (rideDetailsdata != null) {
      data['data'] = rideDetailsdata!.toJson();
    }
    return data;
  }
}

class RideDetailsdata {
  int? id;
  int? idUserApp;
  String? departName;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? place;
  int? numberPoeple;
  int? distance;
  String? duree;
  String? montant;
  String? tipAmount;
  String? tax;
  String? discount;
  String? transactionId;
  String? trajet;
  String? statut;
  String? statutPaiement;
  int? idConducteur;
  int? idPaymentMethod;
  String? creer;
  String? modifier;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? statutCourse;
  int? idConducteurAccepter;
  String? tripObjective;
  String? tripCategory;
  String? ageChildren1;
  String? ageChildren2;
  String? ageChildren3;
  int? feelSafe;
  int? feelSafeDriver;
  int? carDriverConfirmed;
  dynamic deletedAt;
  dynamic updatedAt;

  RideDetailsdata(
      {this.id,
      this.idUserApp,
      this.departName,
      this.destinationName,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.place,
      this.numberPoeple,
      this.distance,
      this.duree,
      this.montant,
      this.tipAmount,
      this.tax,
      this.discount,
      this.transactionId,
      this.trajet,
      this.statut,
      this.statutPaiement,
      this.idConducteur,
      this.idPaymentMethod,
      this.creer,
      this.modifier,
      this.dateRetour,
      this.heureRetour,
      this.statutRound,
      this.statutCourse,
      this.idConducteurAccepter,
      this.tripObjective,
      this.tripCategory,
      this.ageChildren1,
      this.ageChildren2,
      this.ageChildren3,
      this.feelSafe,
      this.feelSafeDriver,
      this.carDriverConfirmed,
      this.deletedAt,
      this.updatedAt});

  RideDetailsdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUserApp = json['id_user_app'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    place = json['place'];
    numberPoeple = json['number_poeple'];
    distance = json['distance'];
    duree = json['duree'];
    montant = json['montant'].toString();
    tipAmount = json['tip_amount'].toString();
    tax = json['tax'].toString();
    discount = json['discount'].toString();
    transactionId = json['transaction_id'].toString();
    trajet = json['trajet'];
    statut = json['statut'];
    statutPaiement = json['statut_paiement'];
    idConducteur = json['id_conducteur'];
    idPaymentMethod = json['id_payment_method'];
    creer = json['creer'];
    modifier = json['modifier'];
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    statutCourse = json['statut_course'];
    idConducteurAccepter = json['id_conducteur_accepter'];
    tripObjective = json['trip_objective'];
    tripCategory = json['trip_category'];
    ageChildren1 = json['age_children1'];
    ageChildren2 = json['age_children2'];
    ageChildren3 = json['age_children3'];
    feelSafe = json['feel_safe'];
    feelSafeDriver = json['feel_safe_driver'];
    carDriverConfirmed = json['car_driver_confirmed'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
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
    data['place'] = place;
    data['number_poeple'] = numberPoeple;
    data['distance'] = distance;
    data['duree'] = duree;
    data['montant'] = montant;
    data['tip_amount'] = tipAmount;
    data['tax'] = tax;
    data['discount'] = discount;
    data['transaction_id'] = transactionId;
    data['trajet'] = trajet;
    data['statut'] = statut;
    data['statut_paiement'] = statutPaiement;
    data['id_conducteur'] = idConducteur;
    data['id_payment_method'] = idPaymentMethod;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['statut_course'] = statutCourse;
    data['id_conducteur_accepter'] = idConducteurAccepter;
    data['trip_objective'] = tripObjective;
    data['trip_category'] = tripCategory;
    data['age_children1'] = ageChildren1;
    data['age_children2'] = ageChildren2;
    data['age_children3'] = ageChildren3;
    data['feel_safe'] = feelSafe;
    data['feel_safe_driver'] = feelSafeDriver;
    data['car_driver_confirmed'] = carDriverConfirmed;
    data['deleted_at'] = deletedAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
