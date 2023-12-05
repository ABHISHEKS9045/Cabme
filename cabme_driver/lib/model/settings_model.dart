class SettingsModel {
  String? success;
  dynamic error;
  String? message;
  Data? data;

  SettingsModel({this.success, this.error, this.message, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? footer;
  String? email;
  String? contactUsEmail;
  String? contactUsAddress;
  String? contactUsPhone;
  String? websiteColor;
  String? driverAppColor;
  String? showRideOtp;
  String? googleMapApiKey;
  String? isSocialMedia;
  String? driverRadios;
  String? creer;
  String? modifier;
  String? appVersion;
  int? decimalDigit;
  String? deliveryDistance;
  String? taxType;
  int? taxValue;
  String? taxName;
  String? currency;

  Data({
    this.id,
    this.title,
    this.footer,
    this.email,
    this.contactUsEmail,
    this.contactUsAddress,
    this.contactUsPhone,
    this.websiteColor,
    this.googleMapApiKey,
    this.showRideOtp,
    this.isSocialMedia,
    this.driverRadios,
    this.creer,
    this.driverAppColor,
    this.modifier,
    this.appVersion,
    this.decimalDigit,
    this.deliveryDistance,
    this.taxType,
    this.taxValue,
    this.taxName,
    this.currency,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    footer = json['footer'];
    email = json['email'];
    contactUsEmail = json['contact_us_email'];
    contactUsAddress = json['contact_us_address'];
    contactUsPhone = json['contact_us_phone'];
    websiteColor = json['website_color'];
    driverAppColor = json['driverapp_color'];
    showRideOtp = json['show_ride_otp'];
    googleMapApiKey = json['google_map_api_key'];
    isSocialMedia = json['is_social_media'];
    driverRadios = json['driver_radios'];
    creer = json['creer'];
    modifier = json['modifier'];
    appVersion = json['app_version'];
    decimalDigit = json['decimal_digit'];
    deliveryDistance = json['delivery_distance'];
    taxType = json['tax_type'];
    taxValue = int.parse(json['tax_value']);
    taxName = json['tax_name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['footer'] = footer;
    data['email'] = email;
    data['contact_us_email'] = contactUsEmail;
    data['contact_us_address'] = contactUsAddress;
    data['contact_us_phone'] = contactUsPhone;
    data['website_color'] = websiteColor;
    data['driverapp_color'] = driverAppColor;
    data['show_ride_otp'] = showRideOtp;
    data['google_map_api_key'] = googleMapApiKey;
    data['is_social_media'] = isSocialMedia;
    data['driver_radios'] = driverRadios;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['app_version'] = appVersion;
    data['decimal_digit'] = decimalDigit;
    data['delivery_distance'] = deliveryDistance;
    data['tax_type'] = taxType;
    data['tax_value'] = taxValue;
    data['tax_name'] = taxName;
    data['currency'] = currency;
    return data;
  }
}
