class ReviewModel {
  String? success;
  String? error;
  ReviewData? data;

  ReviewModel({this.success, this.error, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? ReviewData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReviewData {
  int? id;
  int? rideId;
  double? niveau;
  int? idConducteur;
  int? idUserApp;
  String? statut;
  String? creer;
  String? modifier;
  String? comment;

  ReviewData(
      {this.id,
        this.rideId,
        this.niveau,
        this.idConducteur,
        this.idUserApp,
        this.statut,
        this.creer,
        this.modifier,
        this.comment});

  ReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rideId = json['ride_id'];
    niveau = double.parse(json['niveau'].toString());
    idConducteur = json['id_conducteur'];
    idUserApp = json['id_user_app'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ride_id'] = rideId;
    data['niveau'] = niveau;
    data['id_conducteur'] = idConducteur;
    data['id_user_app'] = idUserApp;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['comment'] = comment;
    return data;
  }
}
