import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/ride_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/add_bank_details/show_bank_details.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/page/car_service_history/car_service_history_screen.dart';
import 'package:cabme_driver/page/completed/completed_screen.dart';
import 'package:cabme_driver/page/confirmed/confirmed_screen.dart';
import 'package:cabme_driver/page/contact_us/contact_us_screen.dart';
import 'package:cabme_driver/page/dash_board.dart';
import 'package:cabme_driver/page/document_status/document_status_screen.dart';
import 'package:cabme_driver/page/localization_screens/localization_screen.dart';
import 'package:cabme_driver/page/my_profile/my_profile_screen.dart';
import 'package:cabme_driver/page/new_ride_screens/new_ride_screen.dart';
import 'package:cabme_driver/page/on_ride_screen/on_ride_screen.dart';
import 'package:cabme_driver/page/privacy_policy/privacy_policy_screen.dart';
import 'package:cabme_driver/page/rejected/rejected_screen.dart';
import 'package:cabme_driver/page/terms_of_service/terms_of_service_screen.dart';
import 'package:cabme_driver/page/wallet/wallet_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class DashBoardController extends GetxController {
  @override
  void onInit() {
    getUsrData();
    getCurrentLocation();
    updateToken();
    updateCurrentLocation();
    super.onInit();
  }

  updateToken() async {
    // use the returned token to send messages to users from your custom server
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      updateFCMToken(token);
    }
  }

  getCurrentLocation() async {
    LocationData location = await Location().getLocation();
    setCurrentLocation(
        location.latitude.toString(), location.longitude.toString());
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
    isActive.value = userModel!.userData!.online == "yes" ? true : false;
  }

  RxBool isActive = true.obs;

  RxInt selectedDrawerIndex = 0.obs;

  final drawerItems = [
    DrawerItem('new_ride'.tr, CupertinoIcons.car_detailed),
    DrawerItem('confirmed'.tr, CupertinoIcons.checkmark_circle),
    DrawerItem('on_ride'.tr, Icons.directions_boat_outlined),
    DrawerItem('completed'.tr, Icons.incomplete_circle_outlined),
    DrawerItem('canceled'.tr, Icons.cancel_outlined),
    DrawerItem('Documents'.tr, Icons.domain_verification),
    DrawerItem('my_profile'.tr, Icons.person_outline),
    DrawerItem('Car Service History'.tr, Icons.miscellaneous_services),
    DrawerItem('My Earnings'.tr, Icons.account_balance_wallet_outlined),
    DrawerItem('Add Bank'.tr, Icons.account_balance),
    DrawerItem('change_language'.tr, Icons.language),
    DrawerItem('contact_us'.tr, Icons.rate_review_outlined),
    DrawerItem('term_service'.tr, Icons.design_services),
    DrawerItem('privacy_policy'.tr, Icons.privacy_tip),
    DrawerItem('sign_out'.tr, Icons.logout),
  ];

  onSelectItem(int index) {
    if (index == 14) {
      Preferences.clearKeyData(Preferences.isLogin);
      Preferences.clearKeyData(Preferences.user);
      Preferences.clearKeyData(Preferences.userId);
      Get.offAll(LoginScreen());
    } else {
      selectedDrawerIndex.value = index;
    }
    Get.back();
  }

  updateCurrentLocation() async {
    RideData? rideData = Constant.getCurrentRideData();
    if (rideData != null) {
      LocationData currentLocation;
      Location location = Location();

      String orderId = (rideData.idUserApp! < rideData.idConducteur!)
          ? '${rideData.idUserApp}-${rideData.id}-${rideData.idConducteur}'
          : '${rideData.idConducteur}-${rideData.id}-${rideData.idUserApp}';

      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.granted) {
        location.enableBackgroundMode(enable: true);
        location.onLocationChanged.listen((locationData) {
          currentLocation = locationData;

          Constant.locationUpdate.doc(orderId).set({
            'driver_latitude': currentLocation.latitude,
            'driver_longitude': currentLocation.longitude,
            'rotation': currentLocation.heading,
          });
        });
      } else {
        location.requestPermission().then((permissionStatus) {
          if (permissionStatus == PermissionStatus.granted) {
            location.enableBackgroundMode(enable: true);
            location.onLocationChanged.listen((locationData) {
              currentLocation = locationData;
              Constant.locationUpdate.doc(orderId).set({
                'driver_latitude': currentLocation.latitude,
                'driver_longitude': currentLocation.longitude,
                'rotation': currentLocation.heading,
              });
            });
          }
        });
      }
    }
  }

  deleteCurrentOrderLocation() {
    RideData? rideData = Constant.getCurrentRideData();
    if (rideData != null) {
      String orderId = (rideData.idUserApp! < rideData.idConducteur!)
          ? '${rideData.idUserApp}-${rideData.id}-${rideData.idConducteur}'
          : '${rideData.idConducteur}-${rideData.id}-${rideData.idUserApp}';

      Location location = Location();
      location.enableBackgroundMode(enable: false);
      Constant.locationUpdate.doc(orderId).delete().then((value) {
        Preferences.clearKeyData(Preferences.currentRideData);
        updateCurrentLocation();
      });
    }
  }

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const NewRideScreen();
      case 1:
        return const ConfirmedScreen();
      case 2:
        return const OnRideScreen();
      case 3:
        return const CompletedScreen();
      case 4:
        return const RejectedScreen();
      case 5:
        return DocumentStatusScreen();
      case 6:
        return MyProfileScreen();
      case 7:
        return const CarServiceBookHistory();
      case 8:
        return WalletScreen();
      case 9:
        return const ShowBankDetails();
      case 10:
        return const LocalizationScreens(intentType: "dashBoard");
      case 11:
        return const ContactUsScreen();
      case 12:
        return const TermsOfServiceScreen();
      case 13:
        return const PrivacyPolicyScreen();
      default:
        return const Text("Error");
    }
  }

  Future<dynamic> setCurrentLocation(String latitude, String longitude) async {
    try {
      Map<String, dynamic> bodyParams = {
        'id_user': Preferences.getInt(Preferences.userId),
        'user_cat': userModel!.userData!.userCat,
        'latitude': latitude,
        'longitude': longitude
      };
      final response = await http.post(Uri.parse(API.updateLocation),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> updateFCMToken(String token) async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId),
        'fcm_id': token,
        'device_id': "",
        'user_cat': userModel!.userData!.userCat
      };
      final response = await http.post(Uri.parse(API.updateToken),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> changeOnlineStatus(bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changeStatus),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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
