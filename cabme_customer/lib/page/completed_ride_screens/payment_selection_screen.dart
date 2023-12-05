// ignore_for_file: library_prefixes, must_be_immutable, unused_local_variable

import 'dart:convert';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/payment_controller.dart';
import 'package:cabme/controller/wallet_controller.dart';
import 'package:cabme/model/PayPalCurrencyCodeErrorModel.dart' as payPalCurrModel;
import 'package:cabme/model/get_payment_txt_token_model.dart';
import 'package:cabme/model/payStackURLModel.dart';
import 'package:cabme/model/paypalErrorSettle.dart';
import 'package:cabme/model/paypalPaymentSettle.dart' as payPalSettel;
import 'package:cabme/model/razorpay_gen_orderid_model.dart';
import 'package:cabme/model/stripe_failed_model.dart';
import 'package:cabme/page/wallet/payStackScreen.dart';
import 'package:cabme/page/wallet/paypalclientToken.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe1;
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../model/payment_setting_model.dart';
import '../wallet/MercadoPagoScreen.dart';
import '../wallet/PayFastScreen.dart';
import '../wallet/paystack_url_genrater.dart';

class PaymentSelectionScreen extends StatelessWidget {
  PaymentSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PaymentController>(
      init: PaymentController(),
      initState: (controller) {
        razorPayController.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        razorPayController.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWaller);
        razorPayController.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(
              backgroundColor: ConstantColors.background,
              elevation: 0,
              centerTitle: true,
              title: const Text("Payment", style: TextStyle(color: Colors.black)),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              )),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/promo_code.png',
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Promo Code",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "Apply promo code",
                                    style: TextStyle(color: Colors.black.withOpacity(0.50), fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                // controller.couponCodeController =
                                //     TextEditingController();
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: true,
                                  builder: (BuildContext context) => couponCodeSheet(
                                    context,
                                    controller,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 2,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/add_payment.png',
                                  width: 36,
                                  height: 36,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Sub Total",
                                  style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                                )),
                                Text('${Constant.currency} ${controller.data.value.montant!.toDouble().toStringAsFixed(Constant.decimal)}',
                                    style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Divider(
                                color: Colors.black.withOpacity(0.40),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Discount",
                                  style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                                )),
                                Text('(-)${Constant.currency} ${controller.discountAmount.value.toStringAsFixed(Constant.decimal)}',
                                    style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Divider(
                                color: Colors.black.withOpacity(0.40),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "${Constant.taxName} ${Constant.taxType == "Percentage" ? "(${Constant.taxValue}%)" : "(${Constant.taxValue})"}",
                                  style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                                )),
                                Text('${Constant.currency} ${controller.taxAmount.value.toStringAsFixed(Constant.decimal)}',
                                    style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800)),
                              ],
                            ),
                            Visibility(
                              visible: controller.tipAmount.value == 0 ? false : true,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                                    child: Divider(
                                      color: Colors.black.withOpacity(0.40),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Driver Tip",
                                        style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                                      )),
                                      Text(
                                        '${Constant.currency} ${controller.tipAmount.value.toStringAsFixed(Constant.decimal)}',
                                        style: TextStyle(
                                          letterSpacing: 1.0,
                                          color: ConstantColors.titleTextColor,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Divider(
                                color: Colors.black.withOpacity(0.40),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    letterSpacing: 1.0,
                                    color: ConstantColors.titleTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${Constant.currency}${controller.getTotalAmount().toStringAsFixed(Constant.decimal)}',
                                  style: TextStyle(
                                    letterSpacing: 1.0,
                                    color: ConstantColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tip to driver",
                                textAlign: TextAlign.left,
                                style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.tipAmount.value == 5) {
                                          controller.tipAmount.value = 0;
                                        } else {
                                          controller.tipAmount.value = 5;
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: controller.tipAmount.value == 5 ? ConstantColors.primary : Colors.white,
                                          border: Border.all(
                                            color: controller.tipAmount.value == 5 ? Colors.transparent : Colors.black.withOpacity(0.20),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 2,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${Constant.currency} 5',
                                          style: TextStyle(color: controller.tipAmount.value == 5 ? Colors.white : Colors.black),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.tipAmount.value == 10) {
                                          controller.tipAmount.value = 0;
                                        } else {
                                          controller.tipAmount.value = 10;
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: controller.tipAmount.value == 10 ? ConstantColors.primary : Colors.white,
                                          border: Border.all(
                                            color: controller.tipAmount.value == 10 ? Colors.transparent : Colors.black.withOpacity(0.20),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 2,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${Constant.currency} 10',
                                          style: TextStyle(color: controller.tipAmount.value == 10 ? Colors.white : Colors.black),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.tipAmount.value == 15) {
                                          controller.tipAmount.value = 0;
                                        } else {
                                          controller.tipAmount.value = 15;
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: controller.tipAmount.value == 15 ? ConstantColors.primary : Colors.white,
                                          border: Border.all(
                                            color: controller.tipAmount.value == 15 ? Colors.transparent : Colors.black.withOpacity(0.20),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 2,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${Constant.currency} 15',
                                          style: TextStyle(color: controller.tipAmount.value == 15 ? Colors.white : Colors.black),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.tipAmount.value == 20) {
                                          controller.tipAmount.value = 0;
                                        } else {
                                          controller.tipAmount.value = 20;
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: controller.tipAmount.value == 20 ? ConstantColors.primary : Colors.white,
                                          border: Border.all(
                                            color: controller.tipAmount.value == 20 ? Colors.transparent : Colors.black.withOpacity(0.20),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 2,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${Constant.currency} 20',
                                          style: TextStyle(color: controller.tipAmount.value == 20 ? Colors.white : Colors.black),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        tipAmountBottomSheet(
                                          context,
                                          controller,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black.withOpacity(0.20),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 2,
                                                offset: const Offset(2, 2),
                                              ),
                                            ],
                                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Other",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Select payment Option", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 16)),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.cash!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.cash.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.cash.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Cash",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = true.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId = controller.paymentSettingModel.value.cash!.idPaymentMethod.toString().obs;
                          },
                          selected: controller.cash.value,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/images/cash.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("Cash"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.myWallet!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.wallet.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.wallet.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Wallet",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            if (double.parse(controller.walletAmount.toString()) >= controller.getTotalAmount()) {
                              controller.wallet = true.obs;
                              controller.selectedRadioTile.value = value!;
                              controller.paymentMethodId = controller.paymentSettingModel.value.myWallet!.idPaymentMethod.toString().obs;
                            } else {
                              controller.wallet = false.obs;
                            }

                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                          },
                          selected: controller.wallet.value,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/icons/walltet_icons.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Wallet"),
                                        const Spacer(),
                                        Text(
                                          "${Constant.currency} ${strToDouble(controller.walletAmount.value.toString())}",
                                        ),
                                      ],
                                    ),
                                    double.parse(strToDouble(controller.walletAmount.value.toString())) >= controller.getTotalAmount()
                                        ? const Text(
                                            "Sufficient Balance",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                            ),
                                          )
                                        : const Text(
                                            "Your Wallet doesn't have sufficient balance",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(color: Colors.red, fontSize: 12),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.strip!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.stripe.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.stripe.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "Stripe",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = true.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId = controller.paymentSettingModel.value.strip!.idPaymentMethod.toString().obs;
                          },
                          selected: controller.stripe.value,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/images/stripe.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("Stripe"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.payStack!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.payStack.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.payStack.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "PayStack",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = true.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId = controller.paymentSettingModel.value.payStack!.idPaymentMethod.toString().obs;
                          },
                          selected: controller.payStack.value,
                          //selectedRadioTile == "strip" ? true : false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/images/paystack.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("PayStack"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.flutterWave!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.flutterWave.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.flutterWave.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "FlutterWave",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = true.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId.value = controller.paymentSettingModel.value.flutterWave!.idPaymentMethod.toString();
                          },
                          selected: controller.flutterWave.value,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/images/flutterwave.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("FlutterWave"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.razorPay!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.razorPay.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.razorPay.value ? ConstantColors.primary : Colors.transparent)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "RazorPay",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = true.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId.value = controller.paymentSettingModel.value.razorPay!.idPaymentMethod.toString();
                          },
                          selected: controller.razorPay.value,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                    child: SizedBox(width: 80, height: 35, child: Image.asset("assets/images/razorpay_@3x.png")),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("RazorPay"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.payFast!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.payFast.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.payFast.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "PayFast",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = true.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId.value = controller.paymentSettingModel.value.payFast!.idPaymentMethod.toString();
                          },
                          selected: controller.payFast.value,
                          //selectedRadioTile == "strip" ? true : false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/images/payfast.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("Pay Fast"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.paytm!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.payTm.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.payTm.value ? ConstantColors.primary : Colors.transparent)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "PayTm",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = true.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId.value = controller.paymentSettingModel.value.paytm!.idPaymentMethod.toString();
                          },
                          selected: controller.payTm.value,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                    child: SizedBox(
                                        width: 80,
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                                          child: Image.asset(
                                            "assets/images/paytm_@3x.png",
                                          ),
                                        )),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("Paytm"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.mercadopago!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.mercadoPago.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.mercadoPago.value ? ConstantColors.primary : Colors.transparent)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "MercadoPago",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = false.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = true.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId.value = controller.paymentSettingModel.value.mercadopago!.idPaymentMethod.toString();
                          },
                          selected: controller.mercadoPago.value,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                    child: SizedBox(
                                      width: 80,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Image.asset(
                                          "assets/images/mercadopago.png",
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("Mercado Pago"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.paymentSettingModel.value.payPal!.isEnabled == "true" ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: controller.paypal.value ? 0 : 2,
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.paypal.value ? ConstantColors.primary : Colors.transparent)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: "PayPal",
                          groupValue: controller.selectedRadioTile.value,
                          onChanged: (String? value) {
                            controller.stripe = false.obs;
                            controller.wallet = false.obs;
                            controller.cash = false.obs;
                            controller.razorPay = false.obs;
                            controller.payTm = false.obs;
                            controller.paypal = true.obs;
                            controller.payStack = false.obs;
                            controller.flutterWave = false.obs;
                            controller.mercadoPago = false.obs;
                            controller.payFast = false.obs;
                            controller.selectedRadioTile.value = value!;
                            controller.paymentMethodId.value = controller.paymentSettingModel.value.payPal!.idPaymentMethod.toString();
                          },
                          selected: controller.paypal.value,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                                    child: SizedBox(
                                        width: 80,
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                                          child: Image.asset("assets/images/paypal_@3x.png"),
                                        )),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("PayPal"),
                            ],
                          ),
                          //toggleable: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: ConstantColors.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total : ${Constant.currency}${controller.getTotalAmount().toStringAsFixed(Constant.decimal)}",
                      style: const TextStyle(letterSpacing: 1.0, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.selectedRadioTile.value == "Wallet") {
                        if (double.parse(controller.walletAmount.toString()) >= controller.getTotalAmount()) {
                          Get.back();
                          Map<String, dynamic> bodyParams = {
                            'id_ride': controller.data.value.id.toString(),
                            'id_driver': controller.data.value.idConducteur.toString(),
                            'id_user_app': controller.data.value.idUserApp.toString(),
                            'amount': controller.subTotalAmount.value.toString(),
                            'paymethod': controller.selectedRadioTile.value,
                            'discount': controller.discountAmount.value.toString(),
                            'tip': controller.tipAmount.value.toString(),
                            'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
                            'commission': Preferences.getString(Preferences.admincommission),
                            'payment_status': "success",
                          };
                          controller.walletDebitAmountRequest(bodyParams).then((value) {
                            if (value != null) {
                              ShowToastDialog.showToast("Payment successfully completed");
                              Get.back(result: true);
                              Get.back();
                            } else {
                              ShowToastDialog.closeLoader();
                            }
                          });
                        } else {
                          ShowToastDialog.showToast("Insufficient wallet balance");
                        }
                      } else if (controller.selectedRadioTile.value == "Cash") {
                        Get.back();
                        Map<String, dynamic> bodyParams = {
                          'id_ride': controller.data.value.id.toString(),
                          'id_driver': controller.data.value.idConducteur.toString(),
                          'id_user_app': controller.data.value.idUserApp.toString(),
                          'amount': controller.subTotalAmount.value.toString(),
                          'paymethod': controller.selectedRadioTile.value,
                          'discount': controller.discountAmount.value.toString(),
                          'tip': controller.tipAmount.value.toString(),
                          'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
                          'commission': Preferences.getString(Preferences.admincommission),
                          'payment_status': "success",
                        };
                        controller.cashPaymentRequest(bodyParams).then((value) {
                          if (value != null) {
                            ShowToastDialog.showToast("Payment successfully completed");
                            Get.back(result: true);
                            Get.back();
                          } else {
                            ShowToastDialog.closeLoader();
                          }
                        });
                      } else if (controller.selectedRadioTile.value == "Stripe") {
                        showLoadingAlert(context);
                        stripeMakePayment(amount: controller.getTotalAmount().toString());
                      } else if (controller.selectedRadioTile.value == "RazorPay") {
                        showLoadingAlert(context);
                        startRazorpayPayment(amount: controller.getTotalAmount().round().toString());
                      } else if (controller.selectedRadioTile.value == "PayTm") {
                        showLoadingAlert(context);
                        getPaytmCheckSum(context, amount: double.parse(controller.getTotalAmount().toString()));
                      } else if (controller.selectedRadioTile.value == "PayPal") {
                        showLoadingAlert(context);
                        _paypalPayment(amount: double.parse(controller.getTotalAmount().toString()));
                      } else if (controller.selectedRadioTile.value == "PayStack") {
                        showLoadingAlert(context);
                        payStackPayment(context, controller.getTotalAmount().toString());
                      } else if (controller.selectedRadioTile.value == "PayFast") {
                        showLoadingAlert(context);
                        payFastPayment(context, controller.getTotalAmount().toString());
                      } else if (controller.selectedRadioTile.value == "FlutterWave") {
                        showLoadingAlert(context);
                        flutterWaveInitiatePayment(context, controller.getTotalAmount().toString());
                      } else if (controller.selectedRadioTile.value == "MercadoPago") {
                        showLoadingAlert(context);
                        mercadoPagoMakePayment(context, controller.getTotalAmount().toString());
                      }
                    },
                    child: Text(
                      "Proceed to Pay".toUpperCase(),
                      style: const TextStyle(letterSpacing: 1.5, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  couponCodeSheet(context, PaymentController controller) {
    return Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 4.3, left: 25, right: 25),
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: BoxDecoration(color: Colors.transparent, border: Border.all(style: BorderStyle.none)),
        child: Column(children: [
          InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 45,
                decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 0.3), color: Colors.transparent, shape: BoxShape.circle),

                // radius: 20,
                child: const Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              )),
          const SizedBox(
            height: 25,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: const Image(
                      image: AssetImage('assets/images/promo_code.png'),
                      width: 100,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Redeem Your Coupons'.tr,
                        style: const TextStyle(fontFamily: 'Poppinssb', color: Color(0XFF2A2A2A), fontSize: 16),
                      )),
                  Text(
                    'Get the discount on all over the budget'.tr,
                    style: const TextStyle(fontFamily: 'Poppinsr', color: Color(0XFF9091A4), letterSpacing: 0.5, height: 2),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    // height: 120,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      dashPattern: const [4, 2],
                      color: const Color(0XFFB7B7B7),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                          color: const Color(0XFFF1F4F7),
                          alignment: Alignment.center,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: controller.couponCodeController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write Coupon Code'.tr,
                              hintStyle: const TextStyle(color: Color(0XFF9091A4)),
                              labelStyle: const TextStyle(color: Color(0XFF333333)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        backgroundColor: ConstantColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (controller.couponCodeController.text.isNotEmpty) {
                          for (var element in controller.coupanCodeList) {
                            if (element.code == controller.couponCodeController.text.toString().trim()) {
                              if (element.type == "Percentage") {
                                var amount = double.parse(element.discount.toString()) / 100;
                                controller.discountAmount.value = controller.subTotalAmount.value * double.parse(amount.toString());
                              } else {
                                controller.discountAmount.value = double.parse(element.discount.toString());
                              }
                            } else {
                              // controller.discountAmount.value = 0.0;
                            }
                          }
                          Navigator.pop(context);
                        } else {
                          ShowToastDialog.showToast("Enter Promo Code");
                        }
                      },
                      child: Text(
                        'REDEEM NOW'.tr,
                        style: const TextStyle(color: Colors.white, fontFamily: 'Poppinsm', fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
          //buildcouponItem(snapshot)
          //  listData(snapshot)
        ]));
  }

  tipAmountBottomSheet(BuildContext context, PaymentController controller) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Enter Tip option",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller.tripAmountTextFieldController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: 'Enter Tip',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: ButtonThem.buildIconButton(context,
                                  iconSize: 16.0,
                                  icon: Icons.arrow_back_ios,
                                  iconColor: Colors.black,
                                  btnHeight: 40,
                                  btnWidthRatio: 0.25,
                                  title: "Cancel",
                                  btnColor: ConstantColors.yellow,
                                  txtColor: Colors.black, onPress: () {
                                Get.back();
                              }),
                            ),
                            Expanded(
                              child: ButtonThem.buildButton(context, btnHeight: 40, title: "Add".tr, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () async {
                                controller.tipAmount.value = double.parse(controller.tripAmountTextFieldController.text);
                                Get.back();
                              }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  String strToDouble(String value) {
    bool isDouble = double.tryParse(value) == null;
    if (!isDouble) {
      String val = double.parse(value).toStringAsFixed(Constant.decimal);
      return val;
    }
    return '0.0';
  }

  transactionAPI() {
    paymentController.transactionAmountRequest().then((value) {
      if (value != null) {
        ShowToastDialog.showToast("Payment successfully completed");
        Get.back(result: true);
        Get.back(result: true);
      } else {
        ShowToastDialog.closeLoader();
      }
    });
  }

  final walletController = Get.put(WalletController());
  final paymentController = Get.put(PaymentController());

  Map<String, dynamic>? paymentIntentData;

  /// strip Payment Gateway
  Future<void> stripeMakePayment({required String amount}) async {
    debugPrint(double.parse(amount).toStringAsFixed(0));
    try {
      paymentIntentData = await walletController.createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        showSnackBarAlert(
          message: "Something went wrong, please contact admin.",
          color: Colors.red.shade400,
        );
      } else {
        await stripe1.Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: stripe1.SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              allowsDelayedPaymentMethods: false,
              googlePay: const stripe1.PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                testEnv: true,
                currencyCode: "USD",
              ),
              style: ThemeMode.system,
              appearance: stripe1.PaymentSheetAppearance(
                colors: stripe1.PaymentSheetAppearanceColors(
                  primary: ConstantColors.primary,
                ),
              ),
              merchantDisplayName: 'Emart',
            ))
            .then((value) {});
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      showSnackBarAlert(
        message: 'exception:$e \n$s',
        color: Colors.red,
      );
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await stripe1.Stripe.instance.presentPaymentSheet().then((value) {
        Get.back();
        transactionAPI();
        paymentIntentData = null;
      });
    } on stripe1.StripeException catch (e) {
      Get.back();
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      showSnackBarAlert(
        message: lom.error.message,
        color: Colors.green,
      );
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.green,
      );
    }
  }

  /// RazorPay Payment Gateway
  final Razorpay razorPayController = Razorpay();

  startRazorpayPayment({required String amount}) {
    debugPrint(double.parse(amount).toStringAsFixed(0));

    try {
      walletController.createOrderRazorPay(amount: int.parse(double.parse(amount).toStringAsFixed(0))).then((value) {
        if (value != null) {
          CreateRazorPayOrderModel result = value;
          openCheckout(
            amount: amount,
            orderId: result.id,
          );
        } else {
          Get.back();
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.",
            color: Colors.red.shade400,
          );
        }
      });
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.red.shade400,
      );
    }
  }

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': walletController.paymentSettingModel.value.razorPay!.key,
      'amount': amount * 100,
      'name': 'Cabme',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': "8888888888", 'email': "demo@demo.com"},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPayController.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    transactionAPI();
  }

  void _handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    showSnackBarAlert(
      message: "Payment Processing Via\n${response.walletName!}",
      color: Colors.blue.shade400,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    showSnackBarAlert(
      message: "Payment Failed!!\n "
          "${jsonDecode(response.message!)['error']['description']}",
      color: Colors.red.shade400,
    );
  }

  /// Paytm Payment Gateway

  getPaytmCheckSum(
    context, {
    required double amount,
  }) async {
    String orderId = DateTime.now().microsecondsSinceEpoch.toString();
    debugPrint(amount.toString());
    String getChecksum = "${API.baseUrl}payments/getpaytmchecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "mid": walletController.paymentSettingModel.value.paytm!.merchantId,
          "order_id": orderId,
          "key_secret": walletController.paymentSettingModel.value.paytm!.merchantKey,
        });

    final data = jsonDecode(response.body);
    await walletController.verifyCheckSum(checkSum: data["code"], amount: amount, orderId: orderId).then((value) {
      initiatePayment(context, amount: amount, orderId: orderId).then((value) {
        GetPaymentTxtTokenModel result = value;
        String callback = "";
        if (walletController.paymentSettingModel.value.paytm!.isSandboxEnabled == "true") {
          callback = "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        } else {
          callback = "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        }

        _startTransaction(
          context,
          txnTokenBy: result.body.txnToken,
          orderId: orderId,
          amount: amount,
        );
      });
    });
  }

  Future<GetPaymentTxtTokenModel> initiatePayment(BuildContext context, {required double amount, required orderId}) async {
    String initiateURL = "${API.baseUrl}payments/initiatepaytmpayment";
    String callback = "";
    if (walletController.paymentSettingModel.value.paytm!.isSandboxEnabled == "true") {
      callback = "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback = "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }
    final response = await http.post(
        Uri.parse(
          initiateURL,
        ),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "mid": walletController.paymentSettingModel.value.paytm!.merchantId,
          "order_id": orderId,
          "key_secret": walletController.paymentSettingModel.value.paytm!.merchantKey,
          "amount": amount.toString(),
          "currency": "INR",
          "callback_url": callback,
          "custId": "30",
          "issandbox": walletController.paymentSettingModel.value.paytm!.isSandboxEnabled == "true" ? "1" : "2",
        });
    final data = jsonDecode(response.body);

    if (data["body"]["txnToken"] == null || data["body"]["txnToken"].toString().isEmpty) {
      Get.back();
      showSnackBarAlert(
        message: "Something went wrong, please contact admin.",
        color: Colors.red.shade400,
      );
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  String result = "";

  Future<void> _startTransaction(
    context, {
    required String txnTokenBy,
    required orderId,
    required double amount,
  }) async {
    try {
      var response = AllInOneSdk.startTransaction(
        walletController.paymentSettingModel.value.paytm!.merchantId.toString(),
        orderId,
        amount.toString(),
        txnTokenBy,
        "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",
        true,
        true,
        true,
      );

      response.then((value) {
        if (value!["RESPMSG"] == "Txn Success") {
          Get.back();
          transactionAPI();
        }
      }).catchError((onError) {
        if (onError is PlatformException) {
          Get.back();

          result = "${onError.message} \n  ${onError.code}";
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.",
            color: Colors.red.shade400,
          );
        } else {
          result = onError.toString();
          Get.back();
          showSnackBarAlert(
            message: "Something went wrong, please contact admin.",
            color: Colors.red.shade400,
          );
        }
      });
    } catch (err) {
      result = err.toString();
      Get.back();
      showSnackBarAlert(
        message: "Something went wrong, please contact admin.",
        color: Colors.red.shade400,
      );
    }
  }

  ///paypal
  _paypalPayment({required double amount}) async {
    PayPalClientTokenGen.paypalClientToken(walletController.paymentSettingModel.value.payPal).then((value) async {
      final String tokenizationKey = walletController.paymentSettingModel.value.payPal!.tokenizationKey.toString();

      var request = BraintreePayPalRequest(amount: amount.toString(), currencyCode: "USD", billingAgreementDescription: "djsghxghf", displayName: 'Cab company');
      BraintreePaymentMethodNonce? resultData;
      try {
        resultData = await Braintree.requestPaypalNonce(tokenizationKey, request);
      } on Exception catch (ex) {
        showSnackBarAlert(
          message: "Something went wrong, please contact admin. $ex",
          color: Colors.red.shade400,
        );
      }

      if (resultData?.nonce != null) {
        PayPalClientTokenGen.paypalSettleAmount(
          payPal: walletController.paymentSettingModel.value.payPal,
          nonceFromTheClient: resultData?.nonce,
          amount: amount.toString(),
          deviceDataFromTheClient: resultData?.typeLabel,
        ).then((value) {
          if (value['success'] == "true" || value['success'] == true) {
            if (value['data']['success'] == "true" || value['data']['success'] == true) {
              payPalSettel.PayPalClientSettleModel settleResult = payPalSettel.PayPalClientSettleModel.fromJson(value);
              if (settleResult.data.success) {
                Get.back();
                transactionAPI();
              }
            } else {
              payPalCurrModel.PayPalCurrencyCodeErrorModel settleResult = payPalCurrModel.PayPalCurrencyCodeErrorModel.fromJson(value);
              Get.back();
              showSnackBarAlert(
                message: "Status : ${settleResult.data.message}",
                color: Colors.red.shade400,
              );
            }
          } else {
            PayPalErrorSettleModel settleResult = PayPalErrorSettleModel.fromJson(value);
            Get.back();
            showSnackBarAlert(
              message: "Status : ${settleResult.data.message}",
              color: Colors.red.shade400,
            );
          }
        });
      } else {
        Get.back(result: false);
        showSnackBarAlert(
          message: "Status : Payment Incomplete!!",
          color: Colors.red.shade400,
        );
      }
    });
  }

  ///PayStack Payment Method
  payStackPayment(BuildContext context, String amount) async {
    var secretKey = walletController.paymentSettingModel.value.payStack!.secretKey.toString();
    await walletController
        .payStackURLGen(
      amount: amount,
      secretKey: secretKey,
    )
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        bool isDone = await Get.to(() => PayStackScreen(
              walletController: walletController,
              secretKey: secretKey,
              initialURl: payStackModel.data.authorizationUrl,
              amount: amount,
              reference: payStackModel.data.reference,
              callBackUrl: walletController.paymentSettingModel.value.payStack!.callbackUrl.toString(),
            ));
        Get.back();

        if (isDone) {
          Get.back();
          transactionAPI();
        } else {
          showSnackBarAlert(message: "Payment UnSuccessful!! \n", color: Colors.red);
        }
      } else {
        showSnackBarAlert(message: "Error while transaction! \n", color: Colors.red);
      }
    });
  }

  ///FlutterWave Payment Method

  flutterWaveInitiatePayment(BuildContext context, String amount) async {
    final style = FlutterwaveStyle(
      appBarText: "Cabme",
      buttonColor: const Color(0xff4774FF),
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      appBarColor: const Color(0xff4774FF),
      dialogCancelTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Color(0xff4774FF),
        fontSize: 18,
      ),
      mainTextStyle: const TextStyle(color: Colors.black, fontSize: 19, letterSpacing: 2),
      dialogBackgroundColor: Colors.white,
      appBarTitleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
    final flutterwave = Flutterwave(
      amount: amount,
      currency: "NGN",
      style: style,
      customer: Customer(
        name: "demo",
        phoneNumber: "1234567890",
        email: "demo@gamil.com",
      ),
      context: context,
      publicKey: walletController.paymentSettingModel.value.flutterWave!.publicKey.toString(),
      paymentOptions: "card, payattitude",
      customization: Customization(
        title: "Cabme",
      ),
      txRef: walletController.ref.value,
      isTestMode: walletController.paymentSettingModel.value.flutterWave!.isSandboxEnabled == 'true' ? true : false,
      redirectUrl: '${API.baseUrl}success',
    );

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response.toString().isNotEmpty) {
        if (response.success!) {
          Get.back();
          transactionAPI();
        } else {
          Get.back();
          showSnackBarAlert(
            message: response.status!,
            color: Colors.red,
          );
        }
      } else {
        Get.back();
        showSnackBarAlert(
          message: "No Response!",
          color: Colors.red,
        );
      }
    } catch (e) {
      Get.back();
      showSnackBarAlert(
        message: e.toString(),
        color: Colors.red,
      );
    }
  }

  ///payFast

  payFastPayment(context, amount) {
    PayFast? payfast = walletController.paymentSettingModel.value.payFast;
    PayStackURLGen.getPayHTML(payFastSettingData: payfast!, amount: amount.toString()).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(
        htmlData: value!,
        payFastSettingData: payfast,
      ));
      if (isDone) {
        Get.back();
        transactionAPI();
      } else {
        Get.back();
        showSnackBarAlert(
          message: "No Response!",
          color: Colors.red,
        );
      }
    });
  }

  ///MercadoPago Payment Method

  mercadoPagoMakePayment(BuildContext context, amount) {
    makePreference(amount).then((result) async {
      if (result.isNotEmpty) {
        var clientId = result['response']['client_id'];
        var preferenceId = result['response']['id'];
        String initPoint = result['response']['init_point'];
        final bool isDone = await Get.to(MercadoPagoScreen(initialURl: initPoint));
        if (isDone) {
          Get.back();
          transactionAPI();
        } else {
          Get.back();
          showSnackBarAlert(
            message: "No Response!",
            color: Colors.red,
          );
        }
      } else {
        Get.back();
        showSnackBarAlert(
          message: "Error while transaction!",
          color: Colors.red,
        );
      }
    });
  }

  Future<Map<String, dynamic>> makePreference(amount) async {
    final mp = MP.fromAccessToken(walletController.paymentSettingModel.value.mercadopago!.accesstoken);
    var pref = {
      "items": [
        {"title": "Wallet TopUp", "quantity": 1, "unit_price": double.parse(amount.toString())}
      ],
      "auto_return": "all",
      "back_urls": {"failure": "${API.baseUrl}payment/failure", "pending": "${API.baseUrl}payment/pending", "success": "${API.baseUrl}payment/success"},
    };

    var result = await mp.createPreference(pref);
    return result;
  }

  showLoadingAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
              Text('Please wait!!'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Please wait!! while completing Transaction',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSnackBarAlert({required String message, Color color = Colors.green}) {
    return Get.showSnackbar(GetSnackBar(
      isDismissible: true,
      message: message,
      backgroundColor: color,
      duration: const Duration(seconds: 8),
    ));
  }
}
