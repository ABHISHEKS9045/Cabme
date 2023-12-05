import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/settings_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SettingsController extends GetxController {
  @override
  Future<void> onInit() async {
    API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
    await getSettingsData().then((value) {
      if (value != null) {
        ConstantColors.primary = Color(
            int.parse(value.data!.driverAppColor!.replaceFirst("#", "0xff")));
        Constant.appVersion = value.data!.appVersion.toString();
        Constant.kGoogleApiKey = value.data!.googleMapApiKey!;
        Constant.distanceUnit = value.data!.deliveryDistance!;
        Constant.decimal = value.data!.decimalDigit!;
        Constant.rideOtp = value.data!.showRideOtp!;
        Constant.taxType = value.data!.taxType!;
        Constant.taxName = value.data!.taxName!;
        Constant.taxValue = value.data!.taxValue!;
        Constant.currency = value.data!.currency!;
        Constant.contactUsEmail = value.data!.contactUsEmail!;
        Constant.contactUsAddress = value.data!.contactUsAddress!;
        Constant.contactUsPhone = value.data!.contactUsPhone!;

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Color(
              int.parse(value.data!.driverAppColor!.replaceFirst("#", "0xff"))),
        ));
      }
    });

    super.onInit();
  }

  Future<SettingsModel?> getSettingsData() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse(API.settings),
        headers: API.authheader,
      );

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();

        return SettingsModel.fromJson(responseBody);
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
