import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/wallet_controller.dart';
import 'package:cabme_driver/model/trancation_model.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'withdrawals_screen.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WalletController>(
        init: WalletController(),
        builder: (walletController) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => walletController.getTrancation(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset('assets/images/earning_bg.png'),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total Earnings'.tr,
                                style: const TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${Constant.currency} ${double.parse(walletController.totalEarn.toString()).toStringAsFixed(Constant.decimal)}",
                                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: walletController.isLoading.value
                            ? Constant.loader()
                            : walletController.transactionList.isEmpty
                                ? Constant.emptyView("No transaction found")
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: walletController.transactionList.length,
                                    itemBuilder: (context, index) {
                                      return showRideTransaction(walletController.transactionList[index]);
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonThem.buildButton(
                      context,
                      title: 'Withdraw'.tr,
                      btnHeight: 45,
                      btnWidthRatio: 0.8,
                      btnColor: ConstantColors.primary,
                      txtColor: Colors.black,
                      onPress: () async {
                        walletController.getBankDetails().then((value) {
                          if (value == null) {
                            ShowToastDialog.showToast('Please Update bank Details');
                          } else {
                            buildShowBottomSheet(context, walletController);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: ButtonThem.buildBorderButton(
                    context,
                    title: 'History'.toUpperCase().tr,
                    btnHeight: 45,
                    btnWidthRatio: 0.8,
                    btnColor: Colors.white,
                    txtColor: Colors.black.withOpacity(0.60),
                    btnBorderColor: Colors.black.withOpacity(0.20),
                    onPress: () async {
                      Get.to(const WithdrawalsScreen());
                    },
                  ))
                ],
              ),
            ),
          );
        });
  }

  showRideTransaction(Data data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      data.creer.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '${Constant.currency} ${data.libelle == "Cash" ? data.adminCommission!.toString().isEmpty ? '0.0' : data.adminCommission!.toString() : data.amount!.toString()}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: ConstantColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_pic_drop_location.png",
                    height: 65,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextScroll(data.departName.toString(), mode: TextScrollMode.bouncing, pauseBetween: const Duration(seconds: 2)),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          TextScroll(data.destinationName.toString(), mode: TextScrollMode.bouncing, pauseBetween: const Duration(seconds: 2))
                          // Text(data.destinationName.toString(),maxLines: 1,),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    data.libelle.toString(),
                    style: TextStyle(color: ConstantColors.yellow, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  buildShowBottomSheet(BuildContext context, WalletController controller) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "Withdraw",
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(border: Border.all(color: ConstantColors.primary.withOpacity(0.40), width: 4), borderRadius: const BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.bankDetails.bankName.toString(),
                                          style: TextStyle(color: ConstantColors.primary, fontSize: 18, fontWeight: FontWeight.w800),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            controller.bankDetails.accountNo.toString(),
                                            style: TextStyle(color: Colors.black.withOpacity(0.80), fontSize: 18, fontWeight: FontWeight.w800),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/icons/bank_name.png',
                                    height: 40,
                                    width: 40,
                                    color: ConstantColors.primary.withOpacity(0.40),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 22),
                                child: Text(
                                  controller.bankDetails.holderName.toString(),
                                  style: TextStyle(color: Colors.black.withOpacity(0.40), fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.bankDetails.otherInfo.toString(),
                                        style: TextStyle(color: Colors.black.withOpacity(0.60), fontSize: 18, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      controller.bankDetails.branchName.toString(),
                                      style: TextStyle(color: Colors.black.withOpacity(0.60), fontSize: 16, fontWeight: FontWeight.w500),
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Amount to Withdraw",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.50),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          prefix: Text(Constant.currency),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Add Note",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.50),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ButtonThem.buildButton(
                            context,
                            title: 'Withdraw'.tr,
                            btnHeight: 45,
                            btnWidthRatio: 0.9,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white,
                            onPress: () async {
                              if (controller.bankDetails.bankName.toString() != 'null') {
                                if (amountController.text.isNotEmpty) {
                                  Map<String, dynamic> bodyParams = {
                                    'driver_id': Preferences.getInt(Preferences.userId),
                                    'amount': amountController.text,
                                    'note': noteController.text,
                                  };
                                  controller.setWithdrawals(bodyParams).then((value) {
                                    if (value != null && value) {
                                      ShowToastDialog.showToast('Amount Withdrawals request successfully');
                                    }
                                  });
                                  Get.back();
                                } else {
                                  ShowToastDialog.showToast('Please enter amount');
                                }
                              } else {
                                ShowToastDialog.showToast('Please add bank details');
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
