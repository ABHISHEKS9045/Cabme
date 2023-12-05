// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/my_profile_controller.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/auth_screens/login_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/responsive.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _passwordKey = GlobalKey();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return GetX<MyProfileController>(
        init: MyProfileController(),
        builder: (myProfileController) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: Responsive.height(16, context),
                        width: Responsive.width(100, context),
                        decoration: BoxDecoration(
                            color: ConstantColors.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.only(top: 30),
                          height: 200,
                          width: 160,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: myProfileController.photoPath.isEmpty
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "https://cabme.siswebapp.com/assets/images/placeholder_image.jpg",
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: myProfileController
                                              .photoPath
                                              .toString(),
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () => buildBottomSheet(
                                      context, myProfileController),
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/icons/edit.png',
                                          width: 22,
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildShowDetails(
                            subtitle: myProfileController.name.toString(),
                            title: "First Name",
                            iconData: Icons.person_outline,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangeData(
                                context,
                                onSubmitBtn: () {
                                  if (fullNameController.text.isNotEmpty) {
                                    Map<String, String> bodyParams = {
                                      'id_user':
                                          Preferences.getInt(Preferences.userId)
                                              .toString(),
                                      'user_cat':
                                          myProfileController.userCat.value,
                                      'prenom': fullNameController.text,
                                    };
                                    myProfileController
                                        .updateFirstName(bodyParams)
                                        .then((value) {
                                      if (value != null) {
                                        if (value["success"] == "success") {
                                          UserModel userModel =
                                              Constant.getUserData();
                                          userModel.data!.prenom =
                                              value['data']['prenom'];
                                          Preferences.setString(
                                              Preferences.user,
                                              jsonEncode(userModel.toJson()));
                                          myProfileController.getUsrData();
                                          dashboardController.getUsrData();
                                          ShowToastDialog.showToast(
                                              value['message']);
                                          Get.back();
                                        } else {
                                          ShowToastDialog.showToast(
                                              value['error']);
                                          Get.back();
                                        }
                                      }
                                    });
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please Enter Name");
                                  }
                                },
                                controller: fullNameController,
                                title: "First Name",
                                iconData: Icons.person_outline,
                                validators: (String? name) {
                                  return null;
                                },
                              );
                            },
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.lastName.toString(),
                            title: "Last Name",
                            iconData: Icons.person_outline,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangeData(
                                context,
                                onSubmitBtn: () {
                                  if (lastNameController.text.isNotEmpty) {
                                    Map<String, String> bodyParams = {
                                      'id_user':
                                          Preferences.getInt(Preferences.userId)
                                              .toString(),
                                      'user_cat':
                                          myProfileController.userCat.value,
                                      'nom': lastNameController.text,
                                    };
                                    myProfileController
                                        .updateLastName(bodyParams)
                                        .then((value) {
                                      if (value != null) {
                                        if (value["success"] == "success") {
                                          UserModel userModel =
                                              Constant.getUserData();
                                          userModel.data!.nom =
                                              value['data']['nom'];
                                          Preferences.setString(
                                              Preferences.user,
                                              jsonEncode(userModel.toJson()));
                                          myProfileController.getUsrData();
                                          dashboardController.getUsrData();
                                          ShowToastDialog.showToast(
                                              value['message']);
                                          Get.back();
                                        } else {
                                          ShowToastDialog.showToast(
                                              value['error']);
                                          Get.back();
                                        }
                                      }
                                    });
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please Enter Name");
                                  }
                                },
                                controller: lastNameController,
                                title: "Last Name",
                                iconData: Icons.person_outline,
                                validators: (String? name) {
                                  return null;
                                },
                              );
                            },
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.phoneNo.toString(),
                            title: "Phone",
                            iconData: CupertinoIcons.phone,
                            isEditIcon: false,
                            onPress: () {},
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.email.toString(),
                            title: "Email",
                            iconData: Icons.email_outlined,
                            isEditIcon: false,
                            onPress: () {},
                          ),
                          buildShowDetails(
                            title: "Password",
                            subtitle: "change password",
                            iconData: Icons.lock_outline,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangePassword(
                                context,
                                myProfileController: myProfileController,
                              );
                            },
                          ),
                          buildShowDetails(
                            title: 'Delete',
                            subtitle: 'Delete Account',
                            isEditIcon: false,
                            iconData: Icons.delete,
                            onPress: () async {
                              await showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Are you sure you want to delete account?',
                                      ),
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ButtonThem.buildButton(
                                                context,
                                                title: 'No',
                                                btnColor: Colors.red,
                                                txtColor: Colors.white,
                                                onPress: () {
                                                  Get.back();
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: ButtonThem.buildButton(
                                                context,
                                                title: 'Yes',
                                                btnColor:
                                                    ConstantColors.primary,
                                                txtColor: Colors.white,
                                                onPress: () {
                                                  myProfileController
                                                      .deleteAccount(
                                                          myProfileController
                                                              .userId
                                                              .toString())
                                                      .then((value) {
                                                    if (value != null) {
                                                      if (value["success"] ==
                                                          "success") {
                                                        ShowToastDialog
                                                            .showToast(value[
                                                                'message']);
                                                        Get.back();
                                                        Preferences
                                                            .clearSharPreference();
                                                        Get.offAll(
                                                            LoginScreen());
                                                      }
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildShowDetails({
    required String title,
    required String subtitle,
    required bool isEditIcon,
    required IconData iconData,
    required Function()? onPress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: ConstantColors.primary.withOpacity(0.08),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(iconData, size: 20, color: Colors.black),
                    )),
              ),
            ],
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          subtitle: Text(subtitle),
          onTap: onPress,
          trailing: Visibility(
            visible: isEditIcon,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/edit.png',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildAlertChangeData(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required IconData iconData,
    required String? Function(String?) validators,
    required Function() onSubmitBtn,
  }) {
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 6,
      title: "Change Information",
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldThem.boxBuildTextField(
                hintText: title,
                controller: controller,
                validators: validators),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ButtonThem.buildButton(context,
                    title: "Save",
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    onPress: onSubmitBtn,
                    btnHeight: 40,
                    btnWidthRatio: 0.3),
                const SizedBox(
                  width: 15,
                ),
                ButtonThem.buildButton(context,
                    title: "Cancel",
                    btnHeight: 40,
                    btnWidthRatio: 0.3,
                    btnColor: ConstantColors.yellow,
                    txtColor: Colors.black,
                    onPress: () => Get.back()),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildAlertChangePassword(
    BuildContext context, {
    required MyProfileController myProfileController,
  }) {
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 6,
      title: "Change Password",
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _passwordKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldThem.boxBuildTextField(
                hintText: "Current Password",
                obscureText: false,
                controller: currentPasswordController,
                validators: (valve) {
                  if (valve!.isNotEmpty) {
                    return null;
                  } else {
                    return "*required";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldThem.boxBuildTextField(
                hintText: "New Password",
                obscureText: false,
                controller: newPasswordController,
                validators: (valve) {
                  if (valve!.isNotEmpty) {
                    return null;
                  } else {
                    return "*required";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldThem.boxBuildTextField(
                hintText: "Confirm Password",
                obscureText: false,
                controller: confirmPasswordController,
                validators: (valve) {
                  if (valve == newPasswordController.text) {
                    return null;
                  } else {
                    return "Password Field do not match  !!";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ButtonThem.buildButton(
                    context,
                    title: "Save",
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    btnHeight: 40,
                    btnWidthRatio: 0.3,
                    onPress: () {
                      if (_passwordKey.currentState!.validate()) {
                        Map<String, String> bodyParams = {
                          'id_user':
                              Preferences.getInt(Preferences.userId).toString(),
                          'user_cat': myProfileController.userCat.value,
                          'anc_mdp': currentPasswordController.text,
                          'new_mdp': newPasswordController.text,
                        };
                        myProfileController
                            .updatePassword(bodyParams)
                            .then((value) {
                          if (value != null) {
                            if (value["success"] == "Success") {
                              ShowToastDialog.showToast(
                                  "Password change successfully");
                              Get.back();
                            } else {
                              ShowToastDialog.showToast(value['error']);
                            }
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ButtonThem.buildButton(context,
                      title: "Cancel",
                      btnHeight: 40,
                      btnWidthRatio: 0.3,
                      btnColor: ConstantColors.yellow,
                      txtColor: Colors.black,
                      onPress: () => Get.back()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildBottomSheet(BuildContext context, MyProfileController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: Responsive.height(22, context),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select",
                      style: TextStyle(
                        color: const Color(0XFF333333).withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller,
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text("Camera"),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller,
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text("Gallery"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile(MyProfileController controller,
      {required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      controller.uploadPhoto(File(image.path)).then((value) {
        if (value != null) {
          if (value["success"] == "Success") {
            UserModel userModel = Constant.getUserData();
            userModel.data!.photoPath = value['data']['photo_path'];
            Preferences.setString(
                Preferences.user, jsonEncode(userModel.toJson()));
            controller.getUsrData();
            dashboardController.getUsrData();
            ShowToastDialog.showToast("Upload successfully!");
          } else {
            ShowToastDialog.showToast(value['error']);
          }
        }
      });
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
