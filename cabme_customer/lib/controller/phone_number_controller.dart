import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/auth_screens/otp_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PhoneNumberController extends GetxController {
  RxString phoneNumber = "".obs;
  RxBool isPhoneValid = false.obs;

  sendCode(String phoneNumber) async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("The provided phone number is not valid.");
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        print("smscode><< ${verificationId}");
        Get.to(OtpScreen(
          phoneNumber: phoneNumber,
          verificationId: verificationId,

        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("You have try many time please send otp after some time");
    });
  }

  Future<bool?> phoneNumberIsExit(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.getExistingUserOrNot), headers: API.authheader, body: jsonEncode(bodyParams));

      log("---->");
      log(bodyParams.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        if (responseBody['data'] == true) {
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
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

  Future<UserModel?> getDataByPhoneNumber(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.getProfileByPhone), headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return UserModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
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
