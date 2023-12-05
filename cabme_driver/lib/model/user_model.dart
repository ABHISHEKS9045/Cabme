class UserModel {
  String? success;
  String? error;
  String? message;
  UserData? userData;

  UserModel({this.success, this.error, this.message, this.userData});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? nom;
  String? prenom;
  String? cnib;
  String? phone;
  String? latitude;
  String? longitude;
  String? email;
  String? statut;
  String? statutLicence;
  String? statutNic;
  String? statutVehicule;
  String? statutCarServiceBook;
  String? statutRoadWorthy;
  String? statusCarImage;
  String? online;
  String? loginType;
  String? photo;
  String? photoPath;
  String? photoLicence;
  String? photoLicencePath;
  String? photoNic;
  String? photoNicPath;
  String? photoCarServiceBook;
  String? photoCarServiceBookPath;
  String? photoRoadWorthy;
  String? photoRoadWorthyPath;
  String? tonotify;
  String? deviceId;
  String? fcmId;
  String? statusApproval;

  String? creer;
  String? modifier;
  String? updatedAt;
  String? amount;
  String? resetPasswordOtp;
  String? resetPasswordOtpModifier;
  String? deletedAt;
  String? userCat;
  String? country;
  String? brand;
  String? model;
  String? color;
  String? numberplate;
  String? accesstoken;

  UserData(
      {this.id,
      this.nom,
      this.prenom,
      this.cnib,
      this.phone,
      this.latitude,
      this.longitude,
      this.email,
      this.statut,
      this.statutLicence,
      this.statutNic,
      this.statutVehicule,
      this.statutCarServiceBook,
      this.statutRoadWorthy,
      this.statusCarImage,
      this.online,
      this.loginType,
      this.photo,
      this.photoPath,
      this.photoLicence,
      this.photoLicencePath,
      this.photoNic,
      this.photoNicPath,
      this.photoCarServiceBook,
      this.photoCarServiceBookPath,
      this.photoRoadWorthy,
      this.photoRoadWorthyPath,
      this.tonotify,
      this.deviceId,
      this.fcmId,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.amount,
      this.resetPasswordOtp,
      this.resetPasswordOtpModifier,
      this.deletedAt,
      this.userCat,
      this.country,
      this.brand,
      this.model,
      this.color,
      this.numberplate,
      this.statusApproval,
      this.accesstoken});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'] ?? '';
    prenom = json['prenom'] ?? '';
    cnib = json['cnib'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    email = json['email'];
    statut = json['statut'];
    statutLicence = json['statut_licence'];
    statutNic = json['statut_nic'];
    statutVehicule = json['statut_vehicule'];
    statutCarServiceBook = json['statut_car_service_book'];
    statutRoadWorthy = json['statut_road_worthy'];
    statusCarImage = json['status_car_image'];
    online = json['online'];
    loginType = json['login_type'];
    photo = json['photo'];
    photoPath = json['photo_path'];
    photoLicence = json['photo_licence'];
    photoLicencePath = json['photo_licence_path'];
    photoNic = json['photo_nic'];
    photoNicPath = json['photo_nic_path'];
    photoCarServiceBook = json['photo_car_service_book'];
    photoCarServiceBookPath = json['photo_car_service_book_path'];
    photoRoadWorthy = json['photo_road_worthy'];
    photoRoadWorthyPath = json['photo_road_worthy_path'];
    tonotify = json['tonotify'];
    deviceId = json['device_id'];
    fcmId = json['fcm_id'];
    statusApproval = json['status_approval'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    amount = json['amount'];
    resetPasswordOtp = json['reset_password_otp'];
    resetPasswordOtpModifier = json['reset_password_otp_modifier'];
    deletedAt = json['deleted_at'];
    userCat = json['user_cat'];
    country = json['country'];
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    numberplate = json['numberplate'];
    accesstoken = json['accesstoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['cnib'] = cnib;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['email'] = email;
    data['statut'] = statut;
    data['statut_licence'] = statutLicence;
    data['statut_nic'] = statutNic;
    data['statut_vehicule'] = statutVehicule;
    data['statut_car_service_book'] = statutCarServiceBook;
    data['statut_road_worthy'] = statutRoadWorthy;
    data['status_car_image'] = statusCarImage;
    data['online'] = online;
    data['login_type'] = loginType;
    data['photo'] = photo;
    data['photo_path'] = photoPath;
    data['photo_licence'] = photoLicence;
    data['photo_licence_path'] = photoLicencePath;
    data['photo_nic'] = photoNic;
    data['photo_nic_path'] = photoNicPath;
    data['photo_car_service_book'] = photoCarServiceBook;
    data['photo_car_service_book_path'] = photoCarServiceBookPath;
    data['photo_road_worthy'] = photoRoadWorthy;
    data['photo_road_worthy_path'] = photoRoadWorthyPath;
    data['tonotify'] = tonotify;
    data['device_id'] = deviceId;
    data['fcm_id'] = fcmId;
    data['status_approval'] = statusApproval;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['amount'] = amount;
    data['reset_password_otp'] = resetPasswordOtp;
    data['reset_password_otp_modifier'] = resetPasswordOtpModifier;
    data['deleted_at'] = deletedAt;
    data['user_cat'] = userCat;
    data['country'] = country;
    data['brand'] = brand;
    data['model'] = model;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['accesstoken'] = accesstoken;
    return data;
  }
}
