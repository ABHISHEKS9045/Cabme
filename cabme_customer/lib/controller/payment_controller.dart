import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/CoupanCodeModel.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/model/ride_details_model.dart';
import 'package:cabme/model/ride_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  var paymentSettingModel = PaymentSettingModel().obs;
  var walletAmount = "0.0".obs;
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController tripAmountTextFieldController = TextEditingController();

  RxBool cash = false.obs;
  RxBool wallet = false.obs;
  RxBool stripe = false.obs;
  RxBool razorPay = false.obs;
  RxBool payTm = false.obs;
  RxBool paypal = false.obs;
  RxBool payStack = false.obs;
  RxBool flutterWave = false.obs;
  RxBool mercadoPago = false.obs;
  RxBool payFast = false.obs;

  @override
  void onInit() {
    getArgument();
    getCoupanCodeData();
    getUsrData();
    paymentSettingModel.value = Constant.getPaymentSetting();

    super.onInit();
  }

  RxDouble subTotalAmount = 0.0.obs;
  RxDouble tipAmount = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble adminCommission = 0.0.obs;

  var data = RideData().obs;
  var coupanCodeList = <CoupanCodeData>[].obs;

  Future<dynamic> getCoupanCodeData() async {
    try {
      final response = await http.get(Uri.parse(API.discountList), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        CoupanCodeModel model = CoupanCodeModel.fromJson(responseBody);
        coupanCodeList.value = model.data!;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        coupanCodeList.clear();
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

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      data.value = argumentData["rideData"];
      selectedRadioTile.value = data.value.payment.toString();
      subTotalAmount.value = double.parse(data.value.montant.toString());
      taxAmount.value = Constant.taxValue.toDouble();

      if (selectedRadioTile.value == "Wallet") {
        wallet.value = true;
      } else if (selectedRadioTile.value == "Cash") {
        cash.value = true;
      } else if (selectedRadioTile.value == "Stripe") {
        stripe.value = true;
      } else if (selectedRadioTile.value == "PayStack") {
        payStack.value = true;
      } else if (selectedRadioTile.value == "FlutterWave") {
        flutterWave.value = true;
      } else if (selectedRadioTile.value == "RazorPay") {
        razorPay.value = true;
      } else if (selectedRadioTile.value == "PayFast") {
        payFast.value = true;
      } else if (selectedRadioTile.value == "PayTm") {
        payTm.value = true;
      } else if (selectedRadioTile.value == "MercadoPago") {
        mercadoPago.value = true;
      } else if (selectedRadioTile.value == "PayPal") {
        paypal.value = true;
      }
    }
    getAmount();
    if (data.value.statutPaiement == "yes") {
      getRideDetailsData(data.value.id.toString());
    }
    update();
  }

  Future<dynamic> getAmount() async {
    try {
      final response = await http.get(Uri.parse("${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app"), headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        walletAmount.value = responseBody['data']['amount'].toString();
        debugPrint("-------->");
        debugPrint(walletAmount.value);
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

  Future<dynamic> getRideDetailsData(String id) async {
    try {
      final response = await http.get(Uri.parse("${API.rideDetails}?ride_id=$id"), headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        RideDetailsModel rideDetailsModel = RideDetailsModel.fromJson(responseBody);

        subTotalAmount.value = double.parse(rideDetailsModel.rideDetailsdata!.montant.toString());
        tipAmount.value = double.parse(rideDetailsModel.rideDetailsdata!.tipAmount.toString());
        // taxAmount.value =
        //     double.parse(rideDetailsModel.rideDetailsdata!.tax.toString());
        discountAmount.value = double.parse(rideDetailsModel.rideDetailsdata!.discount.toString());
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

  double getTotalAmount() {
    if (Constant.taxType == "Percentage") {
      taxAmount.value = Constant.taxValue != 0 ? (subTotalAmount.value - discountAmount.value) * double.parse(Constant.taxValue.toString()) / 100 : 0.0;
    } else {
      taxAmount.value = Constant.taxValue != 0 ? double.parse(Constant.taxValue.toString()) : 0.0;
    }
    // if (paymentSettingModel.value.tax!.taxType == "percentage") {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(
    //               paymentSettingModel.value.tax!.taxAmount.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? double.parse(paymentSettingModel.value.tax!.taxAmount.toString())
    //       : 0.0;
    // }

    return (subTotalAmount.value - discountAmount.value) + tipAmount.value + taxAmount.value;
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  var isLoading = true.obs;
  RxString selectedRadioTile = "".obs;
  RxString paymentMethodId = "".obs;

  Future<dynamic> walletDebitAmountRequest(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      debugPrint(bodyParams.toString());
      final response = await http.post(Uri.parse(API.payRequestWallet), headers: API.header, body: jsonEncode(bodyParams));
      debugPrint(response.request.toString());
      debugPrint(response.body);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> cashPaymentRequest(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.payRequestCash), headers: API.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'].toString().toLowerCase() == "Success".toString().toLowerCase()) {
        transactionAmountRequest();
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> transactionAmountRequest() async {
    Map<String, dynamic> bodyParams = {
      'id_ride': data.value.id.toString(),
      'id_driver': data.value.idConducteur.toString(),
      'id_user_app': data.value.idUserApp.toString(),
      'amount': subTotalAmount.value.toString(),
      'paymethod': selectedRadioTile.value,
      'discount': discountAmount.value.toString(),
      'tip': tipAmount.value.toString(),
      'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
      'payment_status': "success",
    };

    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.payRequestTransaction), headers: API.header, body: jsonEncode(bodyParams));
      log(bodyParams.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        return responseBody;
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }
}
