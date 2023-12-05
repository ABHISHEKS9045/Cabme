import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/page/canceled_ride_screens/canceled_ride_screen.dart';
import 'package:cabme/page/completed_ride_screens/completed_ride_screen.dart';
import 'package:cabme/page/confirmed_ride_screens/confirmed_ride_screen.dart';
import 'package:cabme/page/contact_us/contact_us_screen.dart';
import 'package:cabme/page/coupon_code/coupon_code_screen.dart';
import 'package:cabme/page/dash_board.dart';
import 'package:cabme/page/favotite_ride_screens/favorite_ride_screen.dart';
import 'package:cabme/page/localization_screens/localization_screen.dart';
import 'package:cabme/page/my_profile/my_profile_screen.dart';
import 'package:cabme/page/new_ride_screens/new_ride_screen.dart';
import 'package:cabme/page/on_ride_screens/on_ride_screen.dart';
import 'package:cabme/page/privacy_policy/privacy_policy_screen.dart';
import 'package:cabme/page/rent_vehicle_screens/rent_vehicle_screen.dart';
import 'package:cabme/page/rented_vehicle.dart';
import 'package:cabme/page/terms_service/terms_of_service_screen.dart';
import 'package:cabme/page/wallet/wallet_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';

import '../page/home_screens/home_screen.dart';

class DashBoardController extends GetxController {
  RxInt selectedDrawerIndex = 0.obs;

  @override
  void onInit() {
    getUsrData();
    updateToken();
    getPaymentSettingData();
    super.onInit();
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  updateToken() async {
    // use the returned token to send messages to users from your custom server
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      updateFCMToken(token);
    }
  }

  final drawerItems = [
    DrawerItem('home'.tr, CupertinoIcons.home),
    DrawerItem('favorite_ride'.tr, CupertinoIcons.star),
    DrawerItem('new_ride'.tr, Icons.local_car_wash),
    DrawerItem('confirmed'.tr, CupertinoIcons.checkmark_circle),
    DrawerItem('on_ride'.tr, Icons.directions_boat_outlined),
    DrawerItem("completed".tr, Icons.incomplete_circle),
    DrawerItem('canceled'.tr, Icons.cancel_outlined),
    DrawerItem('rent_a_vehicle'.tr, Icons.car_rental),
    DrawerItem('rented_vehicle'.tr, Icons.car_rental),
    DrawerItem('promo_code'.tr, Icons.discount),
    DrawerItem('my_wallet'.tr, Icons.account_balance_wallet_outlined),
    DrawerItem('my_profile'.tr, Icons.person_outline),
    DrawerItem('change_language'.tr, Icons.language),
    DrawerItem('term_service'.tr, Icons.design_services),
    DrawerItem('privacy_policy'.tr, Icons.privacy_tip),
    DrawerItem('contact_us'.tr, Icons.support_agent),
    DrawerItem('rate_business'.tr, Icons.rate_review_outlined),
    DrawerItem('sign_out'.tr, Icons.logout),
  ];

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const HomeScreen();
      case 1:
        return const FavoriteRideScreen();
      case 2:
        return const NewRideScreen();
      case 3:
        return const ConfirmedRideScreen();
      case 4:
        return OnRideScreens();
      case 5:
        return const CompletedRideScreen();
      case 6:
        return const CanceledRideScreens();
      case 7:
        return RentVehicleScreen();
      case 8:
        return const RentedVehicleScreen();
      case 9:
        return const CouponCodeScreen();
      case 10:
        return WalletScreen();
      case 11:
        return MyProfileScreen();
      case 12:
        return const LocalizationScreens(
          intentType: "dashBoard",
        );
      case 13:
        return const TermsOfServiceScreen();
      case 14:
        return const PrivacyPolicyScreen();
      case 15:
        return const ContactUsScreen();

      default:
        return const Text("Error");
    }
  }

  onSelectItem(int index) {
    if (index == 16) {
      LaunchReview.launch(
        androidAppId: "com.cabme",
        iOSAppId: "com.cabme.ios",
      );
    } else if (index == 17) {
      Preferences.clearKeyData(Preferences.isLogin);
      Preferences.clearKeyData(Preferences.user);
      Preferences.clearKeyData(Preferences.userId);
      Get.offAll(LoginScreen());
    } else {
      selectedDrawerIndex.value = index;
    }
    Get.back();
  }

  Future<dynamic> updateFCMToken(String token) async {
    try {
      Map<String, dynamic> bodyParams = {'user_id': Preferences.getInt(Preferences.userId), 'fcm_id': token, 'device_id': "", 'user_cat': userModel!.data!.userCat};
      final response = await http.post(Uri.parse(API.updateToken), headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        ShowToastDialog.showToast('Something want wrong. Please try again later');
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

  Future<dynamic> getPaymentSettingData() async {
    try {
      final response = await http.get(Uri.parse(API.paymentSetting), headers: API.header);

      debugPrint("---->");
      debugPrint("${API.header}");
      debugPrint(response.body);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        Preferences.setString(Preferences.paymentSetting, jsonEncode(responseBody));
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
