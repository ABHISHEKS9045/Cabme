// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/dash_board_controller.dart';
import 'package:cabme_driver/controller/my_profile_controller.dart';
import 'package:cabme_driver/model/brand_model.dart';
import 'package:cabme_driver/model/model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/text_field_them.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _passwordKey = GlobalKey();

  /// For Profile Information
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  /// For Vehicle Information
  // TextEditingController vBrandController = TextEditingController();
  TextEditingController vColorController = TextEditingController();
  TextEditingController vCarRegistrationController = TextEditingController();

  // TextEditingController vModelController = TextEditingController();

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
                        height: Responsive.height(14, context),
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
                          height: 180,
                          width: 160,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: myProfileController.profileImage.isEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: "https://cabme.siswebapp.com/assets/images/placeholder_image.jpg",
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                            child: CircularProgressIndicator(value: downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: myProfileController.profileImage.toString(),
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                            child: CircularProgressIndicator(value: downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () => buildBottomSheet(context, myProfileController),
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
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  "Personal Information",
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          buildShowDetails(
                            subtitle: myProfileController.name.toString(),
                            title: "First Name",
                            iconData: Icons.person_outline,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangeData(
                                context,
                                onSubmitBtn: () {
                                  if (nameController.text.isNotEmpty) {
                                    myProfileController.updateFirstName({
                                      "id_user": myProfileController.userID.value,
                                      "prenom": nameController.text,
                                      "user_cat": "driver",
                                    }).then((value) {
                                      Get.back();
                                      if (value == true) {
                                        ShowToastDialog.showToast("Updated!!");
                                        dashboardController.getUsrData();
                                      } else {
                                        ShowToastDialog.showToast("Unable to Updated!!");
                                      }
                                    });
                                  }
                                },
                                controller: nameController,
                                title: "Name",
                                validators: (String? value) {
                                  if (value != null || value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "*required";
                                  }
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
                                    myProfileController.updateLastName({
                                      "id_user": myProfileController.userID.value,
                                      "nom": lastNameController.text,
                                      "user_cat": "driver",
                                    }).then((value) {
                                      if (value != null) {
                                        if (value["success"] == "success") {
                                          UserModel userModel = Constant.getUserData();
                                          userModel.userData!.nom = value['data']['nom'];
                                          Preferences.setString(Preferences.user, jsonEncode(userModel.toJson()));
                                          myProfileController.getUsrData();
                                          dashboardController.getUsrData();
                                          ShowToastDialog.showToast(value['message']);
                                          Get.back();
                                        } else {
                                          ShowToastDialog.showToast(value['error']);
                                          Get.back();
                                        }
                                      }
                                    });
                                  }
                                },
                                controller: lastNameController,
                                title: "Last Name",
                                validators: (String? value) {
                                  if (value != null || value!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "*required";
                                  }
                                },
                              );
                            },
                          ),

                          buildShowDetails(
                            subtitle: myProfileController.phoneNo.toString(),
                            title: "Phone",
                            isEditIcon: false,
                            iconData: CupertinoIcons.phone,
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
                            isEditIcon: true,
                            iconData: Icons.lock_outline,
                            onPress: () {
                              buildAlertChangePassword(
                                context,
                                myProfileController: myProfileController,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          /// For Vehicle Information
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  "Vehicle Information",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          buildShowDetails(
                            subtitle: myProfileController.selectedCategory.toString(),
                            title: "Category",
                            iconData: Icons.branding_watermark_outlined,
                            isEditIcon: true,
                            onPress: () {
                              vehicleCategoryDialog(context, myProfileController);
                            },
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.vBrand.toString(),
                            title: "Brand",
                            iconData: Icons.branding_watermark_outlined,
                            isEditIcon: true,
                            onPress: () {
                              myProfileController.getBrand().then((value) {
                                if (value!.isNotEmpty) {
                                  brandDialog(context, value, myProfileController);
                                } else {
                                  ShowToastDialog.showToast("Please contact administrator");
                                }
                              });
                              // buildAlertChangeData(
                              //   context,
                              //   onSubmitBtn: () {
                              // if (vBrandController.text.isNotEmpty) {
                              //   myProfileController.updateVBrand({
                              //     "id_conducteur":
                              //         myProfileController.userID.value,
                              //     "brand": vBrandController.text,
                              //   }).then((value) {
                              //     Get.back();
                              //     if (value == true) {
                              //       ShowToastDialog.showToast("Updated!!");
                              //     } else {
                              //       ShowToastDialog.showToast(
                              //           "Unable to Updated!!");
                              //     }
                              //   });
                              // }
                              //   },
                              //   controller: vBrandController,
                              //   title: "Brand",
                              //   validators: (String? name) {},
                              // );
                            },
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.vModel.toString(),
                            title: "Model",
                            iconData: Icons.branding_watermark_outlined,
                            isEditIcon: true,
                            onPress: () {
                              if (myProfileController.vBrand.value.isNotEmpty) {
                                Map<String, String> bodyParams = {
                                  'brand': myProfileController.vBrand.value,
                                  'vehicle_type': myProfileController.selectedCategoryID.value,
                                };
                                myProfileController.getModel(bodyParams).then((value) {
                                  if (value!.isNotEmpty) {
                                    modelDialog(context, value, myProfileController);
                                  } else {
                                    ShowToastDialog.showToast("Please contact administrator");
                                  }
                                });
                              } else {
                                ShowToastDialog.showToast("Please select brand");
                              }
                              // buildAlertChangeData(
                              //   context,
                              //   onSubmitBtn: () {
                              // if (vModelController.text.isNotEmpty) {
                              //   myProfileController.updateVModel({
                              //     "id_conducteur":
                              //         myProfileController.userID.value,
                              //     "model": vModelController.text,
                              //   }).then((value) {
                              //     Get.back();
                              //     if (value == true) {
                              //       ShowToastDialog.showToast("Updated!!");
                              //     } else {
                              //       ShowToastDialog.showToast(
                              //           "Unable to Updated!!");
                              //     }
                              //   });
                              // }
                              //   },
                              //   controller: vModelController,
                              //   title: "Model",
                              //   validators: (String? phone) {},
                              // );
                            },
                          ),
                          buildShowDetails(
                            subtitle: myProfileController.vColor.toString(),
                            title: "Color",
                            iconData: Icons.color_lens_outlined,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangeData(
                                context,
                                onSubmitBtn: () {
                                  if (vColorController.text.isNotEmpty) {
                                    myProfileController.updateVColor({
                                      "id_conducteur": myProfileController.userID.value,
                                      "color": vColorController.text,
                                    }).then((value) {
                                      Get.back();
                                      if (value == true) {
                                        ShowToastDialog.showToast("Updated!!");
                                      } else {
                                        ShowToastDialog.showToast("Unable to Updated!!");
                                      }
                                    });
                                  }
                                },
                                controller: vColorController,
                                title: "Color",
                                validators: (String? email) {
                                  return null;
                                },
                              );
                            },
                          ),

                          buildShowDetails(
                            subtitle: myProfileController.vCarRegistration.toString(),
                            title: "Car Registration",
                            iconData: Icons.branding_watermark_outlined,
                            isEditIcon: true,
                            onPress: () {
                              buildAlertChangeData(
                                context,
                                onSubmitBtn: () {
                                  if (vCarRegistrationController.text.isNotEmpty) {
                                    myProfileController.updateVNumberPlate({
                                      "id_conducteur": myProfileController.userID.value,
                                      "numberplate": vCarRegistrationController.text,
                                    }).then((value) {
                                      Get.back();
                                      if (value == true) {
                                        ShowToastDialog.showToast("Updated!!");
                                      } else {
                                        ShowToastDialog.showToast("Unable to Updated!!");
                                      }
                                    });
                                  }
                                },
                                controller: vCarRegistrationController,
                                title: "Car Registration",
                                validators: (String? email) {
                                  return null;
                                },
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
                                                btnColor: ConstantColors.primary,
                                                txtColor: Colors.white,
                                                onPress: () {
                                                  myProfileController.deleteAccount(myProfileController.userID.toString()).then((value) {
                                                    if (value != null) {
                                                      if (value["success"] == "success") {
                                                        ShowToastDialog.showToast(value['message']);
                                                        Get.back();
                                                        Preferences.clearSharPreference();
                                                        Get.offAll(LoginScreen());
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
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(iconData, size: 28),
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
        child: Image.asset(
          'assets/icons/edit.png',
          width: 22,
          height: 22,
        ),
      ),
    );
  }

  vehicleCategoryDialog(BuildContext context, MyProfileController myProfileController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Catogory list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: myProfileController.vehicleCategoryList.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: myProfileController.vehicleCategoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                myProfileController.selectedCategory.value = myProfileController.vehicleCategoryList[index].libelle.toString();
                                myProfileController.selectedCategoryID.value = myProfileController.vehicleCategoryList[index].id.toString();
                                if (myProfileController.selectedCategoryID.value.isNotEmpty) {
                                  myProfileController.updateVCategory({
                                    "id_conducteur": myProfileController.userID.value,
                                    "id_vehicle_type": myProfileController.selectedCategoryID.value,
                                  }).then((value) {
                                    Get.back();
                                    if (value == true) {
                                      ShowToastDialog.showToast("Updated!!");
                                    } else {
                                      ShowToastDialog.showToast("Unable to Updated!!");
                                    }
                                  });
                                }
                                Get.back();
                              },
                              child: Text(myProfileController.vehicleCategoryList[index].libelle.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }

  brandDialog(BuildContext context, List<BrandData>? brandList, MyProfileController myProfileController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Brand list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: brandList!.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                myProfileController.vBrand.value = brandList[index].name.toString();
                                myProfileController.vBrandId.value = brandList[index].id.toString();
                                if (myProfileController.vBrand.value.isNotEmpty) {
                                  myProfileController.updateVBrand({
                                    "id_conducteur": myProfileController.userID.value,
                                    "brand": myProfileController.vBrandId.value,
                                  }).then((value) {
                                    Get.back();
                                    if (value == true) {
                                      ShowToastDialog.showToast("Updated!!");
                                    } else {
                                      ShowToastDialog.showToast("Unable to Updated!!");
                                    }
                                  });
                                }
                                Get.back();
                              },
                              child: Text(brandList[index].name.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }

  modelDialog(BuildContext context, List<ModelData>? brandList, MyProfileController myProfileController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Model list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: brandList!.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                myProfileController.vModel.value = brandList[index].name.toString();
                                myProfileController.vModelId.value = brandList[index].id.toString();
                                if (myProfileController.vModel.value.isNotEmpty) {
                                  myProfileController.updateVModel({
                                    "id_conducteur": myProfileController.userID.value,
                                    "model": myProfileController.vModelId.value,
                                  }).then((value) {
                                    Get.back();
                                    if (value == true) {
                                      ShowToastDialog.showToast("Updated!!");
                                    } else {
                                      ShowToastDialog.showToast("Unable to Updated!!");
                                    }
                                  });
                                }
                                Get.back();
                              },
                              child: Text(brandList[index].name.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }

  buildAlertChangeData(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required String? Function(String?) validators,
    required Function() onSubmitBtn,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey();
    return Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 6,
      title: "Change Information",
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldThem.boxBuildTextField(hintText: title, controller: controller, validators: validators),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ButtonThem.buildButton(context, title: "Save", btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: onSubmitBtn, btnHeight: 40, btnWidthRatio: 0.3),
                  const SizedBox(
                    width: 15,
                  ),
                  ButtonThem.buildBorderButton(context,
                      title: "Cancel", btnHeight: 40, btnWidthRatio: 0.3, btnColor: Colors.white, txtColor: ConstantColors.primary, onPress: () => Get.back(), btnBorderColor: ConstantColors.primary),
                ],
              )
            ],
          ),
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
                  if (valve!.isNotEmpty) {
                    if (valve == newPasswordController.text) {
                      return null;
                    } else {
                      return "Password Field do not match  !!";
                    }
                  } else {
                    return "*required";
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
                        myProfileController.updatePassword({
                          "id_driver": myProfileController.userID.value,
                          "anc_mdp": currentPasswordController.text,
                          "new_mdp": newPasswordController.text,
                          "user_cat": "driver",
                        }).then((value) {
                          Get.back();
                          if (value == true) {
                            ShowToastDialog.showToast("Password Updated!!");
                          } else {
                            ShowToastDialog.showToast(value.toString());
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ButtonThem.buildBorderButton(context,
                      title: "Cancel", btnHeight: 40, btnWidthRatio: 0.3, btnColor: Colors.white, txtColor: ConstantColors.primary, onPress: () => Get.back(), btnBorderColor: ConstantColors.primary),
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
                                onPressed: () => pickFile1(controller, source: ImageSource.camera),
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
                                onPressed: () => pickFile1(controller, source: ImageSource.gallery),
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

  requiredValidator(String? value) {
    if (value != null || value!.isNotEmpty) {
      return null;
    } else {
      return "*required";
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile1(MyProfileController controller, {required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      controller.uploadPhoto(File(image.path)).then((value) async {
        if (value != null) {
          if (value["success"] == "Success") {
            UserModel userModel = Constant.getUserData();
            userModel.userData!.photoPath = value['data']['photo_path'];
            Preferences.setString(Preferences.user, jsonEncode(userModel.toJson()));
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
