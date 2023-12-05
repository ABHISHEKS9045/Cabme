// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/phone_number_controller.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:cabme_driver/page/dash_board.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../themes/constant_colors.dart';
import 'signup_screen.dart';

class OtpScreen extends StatelessWidget {
  String? phoneNumber;
  String? verificationId;

  OtpScreen({Key? key, required this.phoneNumber, required this.verificationId}) : super(key: key);

  final controller = Get.put(PhoneNumberController());
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColors.background,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Enter OTP".tr,
                          style: const TextStyle(letterSpacing: 0.60, fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                            width: 80,
                            child: Divider(
                              color: ConstantColors.yellow1,
                              thickness: 3,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: PinCodeTextField(
                            length: 6,
                            appContext: context,
                            keyboardType: TextInputType.phone,
                            pinTheme: PinTheme(
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeColor: ConstantColors.textFieldBoarderColor,
                              selectedColor: ConstantColors.textFieldBoarderColor,
                              inactiveColor: ConstantColors.textFieldBoarderColor,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enableActiveFill: true,
                            cursorColor: ConstantColors.primary,
                            controller: textEditingController,
                            onCompleted: (v) async {},
                            onChanged: (value) {},
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Done'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.black,
                              onPress: () async {
                                FocusScope.of(context).unfocus();
                                if (textEditingController.text.length == 6) {
                                  ShowToastDialog.showLoader("Verify OTP");
                                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId.toString(), smsCode: textEditingController.text);
                                  await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                    Map<String, String> bodyParams = {
                                      'phone': phoneNumber.toString(),
                                      'user_cat': "driver",
                                    };
                                    await controller.phoneNumberIsExit(bodyParams).then((value) async {
                                      if (value== true) {
                                        Map<String, String> bodyParams = {
                                          'phone': phoneNumber.toString(),
                                          'user_cat': "driver",
                                        };
                                        await controller.getDataByPhoneNumber(bodyParams).then((value) {
                                          if (value != null) {
                                            if (value.success == "success") {
                                              Preferences.setString(Preferences.user, jsonEncode(value));
                                              UserData? userData = value.userData;
                                              Preferences.setInt(Preferences.userId, userData!.id!);
                                              Preferences.setString(Preferences.accesstoken, value.userData!.accesstoken.toString());
                                              API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);

                                              if (userData.statutVehicule != "yes" || userData.statutVehicule!.isEmpty) {
                                                Get.to(() => VehicleInfoScreen());
                                              }
                                              // else if (userData.photoPath == null) {
                                              //   Get.to(AddProfilePhotoScreen(fromOtp: true));
                                              // }
                                              // else if (userData.photoLicencePath == null) {
                                              //   Get.to(() => DocumentVerifyScreen(
                                              //         fromOtp: true,
                                              //       ));
                                              // }
                                              // else if (userData.photoRoadWorthyPath == null) {
                                              //   Get.to(() => const AddRoadWorthyDocScreen(
                                              //         fromOtp: true,
                                              //       ));
                                              // } else if (userData.photoCarServiceBookPath == null) {
                                              //   Get.to(() => AddCarServiceBookScreen(
                                              //         fromOtp: true,
                                              //       ));
                                              // }
                                              else {
                                                Preferences.setBoolean(Preferences.isLogin, true);
                                                Get.offAll(() => DashBoard());

                                                // if(userData.statut)
                                                // Get.offAll(LoginScreen());
                                              }
                                            } else {
                                              ShowToastDialog.showToast(value.error);
                                            }
                                          }
                                        });
                                      }  else if(value == false){
                                        ShowToastDialog.closeLoader();
                                        Get.off(SignupScreen(
                                          phoneNumber: phoneNumber.toString(),
                                        ));
                                      }
                                    });
                                  });
                                } else {
                                  ShowToastDialog.showToast("Please Enter OTP");
                                }
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
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
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
