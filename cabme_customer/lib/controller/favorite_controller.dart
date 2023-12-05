import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/favorite_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoriteController extends GetxController {
  var isLoading = true.obs;
  var favouriteList = <Data>[].obs;

  @override
  void onInit() {
    favouriteData();
    super.onInit();
  }

  Future<dynamic> favouriteData() async {
    try {
      final response = await http.get(Uri.parse("${API.favorite}?id_user_app=${Preferences.getInt(Preferences.userId)}"), headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        isLoading.value = false;
        FavoriteModel model = FavoriteModel.fromJson(responseBody);
        favouriteList.value = model.data!;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
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

  Future<dynamic> deleteFavouriteRide(String favId) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse("${API.deleteFavouriteRide}?id_ride_fav=$favId"), headers: API.header);
      
      
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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
