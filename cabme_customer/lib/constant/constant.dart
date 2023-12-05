// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/chats_screen/conversation_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Constant {

   static String kGoogleApiKey = "AIzaSyCzsSTpM6RkMUMlyfxZK3Od30cKoGtIDdk";
   // static String kGoogleApiKey = "AIzaSyAXdZsci8RH_GLRp3UVPDuhHRLDUzopgH0";
  static String distanceUnit = "KM";
  static String appVersion = "1.0";
  static int decimal = 2;
  static int taxValue = 0;
  static String currency = "\$";
  static String taxType = 'Percentage';
  static String taxName = 'Tax';
  static String contactUsEmail = "", contactUsAddress = "", contactUsPhone = "";
  static String rideOtp = "yes";

  static String stripePublishablekey = "pk_test_51Kaaj9SE3HQdbrEJneDaJ2aqIyX1SBpYhtcMKfwchyohSZGp53F75LojfdGTNDUwsDV5p6x5BnbATcrerModlHWa00WWm5Yf5h";

  static CollectionReference conversation = FirebaseFirestore.instance.collection('conversation');
  static CollectionReference location_update = FirebaseFirestore.instance.collection('ride_location_update');

  static String getUuid() {
    var uuid = const Uuid();
    return uuid.v1();
  }

  static UserModel getUserData() {
    final String user = Preferences.getString(Preferences.user);
    Map<String, dynamic> userMap = jsonDecode(user);
    return UserModel.fromJson(userMap);
  }

  static PaymentSettingModel getPaymentSetting() {
    final String user = Preferences.getString(Preferences.paymentSetting);
    if (user.isNotEmpty) {
      Map<String, dynamic> userMap = jsonDecode(user);
      return PaymentSettingModel.fromJson(userMap);
    }
    return PaymentSettingModel();
  }

  static Widget emptyView(BuildContext context, String msg, bool isButtonShow) {
    final controllerDashBoard = Get.put(DashBoardController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset('assets/images/empty_placeholde.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Visibility(
          visible: isButtonShow,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ButtonThem.buildButton(
              context,
              title: 'Book now'.tr,
              btnHeight: 45,
              btnWidthRatio: 0.8,
              btnColor: ConstantColors.primary,
              txtColor: Colors.white,
              onPress: () async {
                controllerDashBoard.onSelectItem(0);
              },
            ),
          ),
        )
      ],
    );
  }

  static Widget loader() {
    return Center(
      child: CircularProgressIndicator(color: ConstantColors.primary),
    );
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static Future<void> launchMapURl(String? latitude, String? longLatitude) async {
    String appleUrl = 'https://maps.apple.com/?saddr=&daddr=$latitude,$longLatitude&directionsmode=driving';
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longLatitude';

    if (Platform.isIOS) {
      if (await canLaunch(appleUrl)) {
        await launch(appleUrl);
      } else {
        if (await canLaunch(googleUrl)) {
          await launch(googleUrl);
        } else {
          throw 'Could not open the map.';
        }
      }
    }
  }

  static Future<Url> uploadChatImageToFireStorage(File image) async {
    ShowToastDialog.showLoader('Uploading image...');
    var uniqueID = const Uuid().v4();
    Reference upload = FirebaseStorage.instance.ref().child('images/$uniqueID.png');

    File compressedImage = await compressImage(image);
    debugPrint(compressedImage.path);
    UploadTask uploadTask = upload.putFile(compressedImage);

    uploadTask.snapshotEvents.listen((event) {
      ShowToastDialog.showLoader('Uploading image ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    uploadTask.whenComplete(() {}).catchError((onError) {
      ShowToastDialog.closeLoader();
      debugPrint(onError.message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    ShowToastDialog.closeLoader();
    return Url(mime: metaData.contentType ?? 'image', url: downloadUrl.toString());
  }

  static Future<File> compressImage(File file) async {
    File compressedImage = await FlutterNativeImage.compressImage(
      file.path,
      quality: 25,
    );
    return compressedImage;
  }

  static Future<ChatVideoContainer> uploadChatVideoToFireStorage(File video) async {
    ShowToastDialog.showLoader('Uploading video');
    var uniqueID = const Uuid().v4();
    Reference upload = FirebaseStorage.instance.ref().child('videos/$uniqueID.mp4');
    File compressedVideo = await _compressVideo(video);
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
    uploadTask.snapshotEvents.listen((event) {
      ShowToastDialog.showLoader('Uploading video ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    final uint8list = await VideoThumbnail.thumbnailFile(video: downloadUrl, thumbnailPath: (await getTemporaryDirectory()).path, imageFormat: ImageFormat.PNG);
    final file = File(uint8list ?? '');
    String thumbnailDownloadUrl = await uploadVideoThumbnailToFireStorage(file);
    ShowToastDialog.closeLoader();
    return ChatVideoContainer(videoUrl: Url(url: downloadUrl.toString(), mime: metaData.contentType ?? 'video'), thumbnailUrl: thumbnailDownloadUrl);
  }

  static Future<File> _compressVideo(File file) async {
    MediaInfo? info = await VideoCompress.compressVideo(file.path, quality: VideoQuality.DefaultQuality, deleteOrigin: false, includeAudio: true, frameRate: 24);
    if (info != null) {
      File compressedVideo = File(info.path!);
      return compressedVideo;
    } else {
      return file;
    }
  }

  static Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = const Uuid().v4();
    Reference upload = FirebaseStorage.instance.ref().child('thumbnails/$uniqueID.png');
    File compressedImage = await compressImage(file);
    UploadTask uploadTask = upload.putFile(compressedImage);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}

class Url {
  String mime;

  String url;

  Url({this.mime = '', this.url = ''});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Url(mime: parsedJson['mime'] ?? '', url: parsedJson['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': mime, 'url': url};
  }
}
