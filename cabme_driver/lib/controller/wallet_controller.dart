import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/bank_details_model.dart';
import 'package:cabme_driver/model/trancation_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  RxString totalEarn = "0".obs;
  RxDouble dailyEarn = 0.0.obs;
  RxDouble weeklyEarn = 0.0.obs;

  @override
  void onInit() {
    getTrancation();
    super.onInit();
  }

  var bankDetails = BankData();

  Future<dynamic> getBankDetails() async {
    ShowToastDialog.showLoader("Please wait");
    try {
      final response = await http.get(Uri.parse("${API.bankDetails}?driver_id=${Preferences.getInt(Preferences.userId)}"), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        BankDetailsModel model = BankDetailsModel.fromJson(responseBody);
        bankDetails = model.data!;
        return bankDetails;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error'].toString());
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

  var isLoading = true.obs;
  var transactionList = <Data>[].obs;

  Future<dynamic> getTrancation() async {
    try {
      final response = await http.get(Uri.parse("${API.walletHistory}?id_diver=${Preferences.getInt(Preferences.userId)}"), headers: API.header);
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        TruncationModel model = TruncationModel.fromJson(responseBody);
        transactionList.value = model.data!;
        totalEarn.value = model.totalEarnings!.toString();
        log("transaction History ${response.body}");
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        transactionList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<bool?> setWithdrawals(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.withdrawalsRequest), headers: API.header, body: jsonEncode(bodyParams));
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return true;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
        return null;
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
