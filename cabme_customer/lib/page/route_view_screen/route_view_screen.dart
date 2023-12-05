import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/controller/ride_details_controller.dart';
import 'package:cabme/model/ride_model.dart';
import 'package:cabme/page/chats_screen/conversation_screen.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/custom_alert_dialog.dart';
import 'package:cabme/themes/custom_dialog_box.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RouteViewScreen extends StatefulWidget {
  const RouteViewScreen({Key? key}) : super(key: key);

  @override
  State<RouteViewScreen> createState() => _RouteViewScreenState();
}

class _RouteViewScreenState extends State<RouteViewScreen> {
  dynamic argumentData = Get.arguments;

  GoogleMapController? _controller;

  Map<PolylineId, Polyline> polyLines = {};

  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;

  late LatLng departureLatLong;
  late LatLng destinationLatLong;

  final Map<String, Marker> _markers = {};

  String? type;
  RideData? rideData;
  String driverEstimateArrivalTime = '';

  @override
  void initState() {
    getArgumentData();
    setIcons();

    super.initState();
  }

  final controllerRideDetails = Get.put(RideDetailsController());
  final controllerDashBoard = Get.put(DashBoardController());

  getArgumentData() {
    if (argumentData != null) {
      type = argumentData['type'];
      rideData = argumentData['data'];

      departureLatLong = LatLng(double.parse(rideData!.latitudeDepart.toString()), double.parse(rideData!.longitudeDepart.toString()));
      destinationLatLong = LatLng(double.parse(rideData!.latitudeArrivee.toString()), double.parse(rideData!.longitudeArrivee.toString()));

      if (rideData!.statut == "on ride" || rideData!.statut == 'confirmed') {
        String orderId =
            (rideData!.idUserApp! < rideData!.idConducteur!) ? '${rideData!.idUserApp}-${rideData!.id}-${rideData!.idConducteur}' : '${rideData!.idConducteur}-${rideData!.id}-${rideData!.idUserApp}';

        Constant.location_update.doc(orderId).snapshots().listen((event) async {
          Dio dio = Dio();
          dynamic response = await dio.get(
              "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${rideData!.latitudeDepart},${rideData!.longitudeDepart}&destinations=${event['driver_latitude']},${event['driver_longitude']}&key=${Constant.kGoogleApiKey}");

          driverEstimateArrivalTime = response.data['rows'][0]['elements'][0]['duration']['text'].toString();

          setState(() {
            var latitude = event['driver_latitude'];
            var longLatitude = event['driver_longitude'];
            var rotation = event['rotation'];
            departureLatLong = LatLng(double.parse(latitude.toString()), double.parse(longLatitude.toString()));
            _markers[rideData!.id.toString()] = Marker(
                markerId: MarkerId(rideData!.id.toString()), infoWindow: InfoWindow(title: rideData!.prenomConducteur.toString()), position: departureLatLong, icon: taxiIcon!, rotation: rotation);
            getDirections(dLat: latitude, dLng: longLatitude);
          });
        });
      } else {
        getDirections(dLat: 0.0, dLng: 0.0);
      }
    }
  }

  setIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/pickup.png")
        .then((value) {
      departureIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/dropoff.png")
        .then((value) {
      destinationIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(10, 10),
            ),
            "assets/icons/ic_taxi.png")
        .then((value) {
      taxiIcon = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              initialCameraPosition: const CameraPosition(
                target: LatLng(48.8561, 2.2930),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _controller!.moveCamera(CameraUpdate.newLatLngZoom(departureLatLong, 12));
              },
              polylines: Set<Polyline>.of(polyLines.values),
              markers: _markers.values.toSet(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(4),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/ic_pic_drop_location.png",
                                height: 70,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rideData!.departName.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Divider(),
                                      Text(
                                        rideData!.destinationName.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                type!,
                                style: TextStyle(color: ConstantColors.primary),
                              )
                            ],
                          ),
                          if (rideData!.statut == 'confirmed')
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Driver Estimate Arrival Time : ',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    driverEstimateArrivalTime,
                                    style: TextStyle(color: ConstantColors.yellow, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          Visibility(
                            visible: Constant.rideOtp.toString() == 'yes' && rideData!.statut == 'confirmed' ? true : false,
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.grey.withOpacity(0.20),
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'OTP : ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      rideData!.otp.toString(),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.20),
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icons/passenger.png',
                                              height: 22,
                                              width: 22,
                                              color: ConstantColors.yellow,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(" ${rideData!.numberPoeple.toString()}",
                                                  //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            Text(
                                              Constant.currency,
                                              style: TextStyle(
                                                color: ConstantColors.yellow,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            // Image.asset(
                                            //   'assets/icons/price.png',
                                            //   height: 22,
                                            //   width: 22,
                                            //   color: ConstantColors.yellow,
                                            // ),
                                            Text(
                                              "${Constant.currency} ${rideData!.montant!.toStringAsFixed(Constant.decimal)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icons/ic_distance.png',
                                              height: 22,
                                              width: 22,
                                              color: ConstantColors.yellow,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text("${rideData!.distance.toString()} ${rideData!.distanceUnit}",
                                                  //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icons/time.png',
                                              height: 22,
                                              width: 22,
                                              color: ConstantColors.yellow,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(rideData!.duree.toString(),
                                                  //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: rideData!.photoPath.toString(),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Constant.loader(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${rideData!.prenomConducteur.toString()} ${rideData!.nomConducteur.toString()}",
                                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                        StarRating(size: 18, rating: rideData!.moyenne!, color: ConstantColors.yellow),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Visibility(
                                          visible: rideData!.statut == "confirmed" ? true : false,
                                          child: InkWell(
                                              onTap: () {
                                                Get.to(ConversationScreen(), arguments: {
                                                  'receiverId': rideData!.idConducteur,
                                                  'orderId': rideData!.id,
                                                  'receiverName': "${rideData!.prenomConducteur} ${rideData!.nomConducteur}",
                                                  'receiverPhoto': rideData!.photoPath
                                                });
                                              },
                                              child: Image.asset(
                                                'assets/icons/chat_icon.png',
                                                height: 36,
                                                width: 36,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: InkWell(
                                              onTap: () {
                                                Constant.makePhoneCall(rideData!.driverPhone.toString());
                                              },
                                              child: Image.asset(
                                                'assets/icons/call_icon.png',
                                                height: 36,
                                                width: 36,
                                              )),
                                        ),
                                        Visibility(
                                          visible: rideData!.statut == "on ride" ? true : false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: ButtonThem.buildButton(
                                              context,
                                              title: 'sos'.tr,
                                              btnHeight: 35,
                                              btnWidthRatio: 0.2,
                                              btnColor: ConstantColors.primary,
                                              txtColor: Colors.white,
                                              onPress: () async {
                                                LocationData location = await Location().getLocation();
                                                Map<String, dynamic> bodyParams = {
                                                  'lat': location.latitude,
                                                  'lng': location.longitude,
                                                  'ride_id': rideData!.id,
                                                };
                                                controllerRideDetails.sos(bodyParams).then((value) {
                                                  if (value != null) {
                                                    if (value['success'] == "success") {
                                                      ShowToastDialog.showToast(value['message']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(rideData!.dateRetour.toString(), style: const TextStyle(color: Colors.black26, fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.20),
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Visibility(
                        visible: rideData!.statut == "on ride" ? true : false,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'safe_message'.tr,
                              btnHeight: 45,
                              btnWidthRatio: 0.8,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              onPress: () async {
                                LocationData location = await Location().getLocation();
                                Map<String, dynamic> bodyParams = {
                                  'lat': location.latitude,
                                  'lng': location.longitude,
                                  'user_id': Preferences.getInt(Preferences.userId).toString(),
                                  'user_name': "${controllerRideDetails.userModel!.data!.prenom} ${controllerRideDetails.userModel!.data!.nom}",
                                  'user_cat': controllerRideDetails.userModel!.data!.userCat,
                                  'id_driver': rideData!.idConducteur,
                                  'feel_safe': 0,
                                  'trip_id': rideData!.id,
                                };
                                controllerRideDetails.feelNotSafe(bodyParams).then((value) {
                                  if (value != null) {
                                    if (value['success'] == "success") {
                                      ShowToastDialog.showToast("Report submitted");
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: rideData!.statut == "confirmed" ? true : false,
                      //   child: Expanded(
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(bottom: 5),
                      //       child: ButtonThem.buildButton(
                      //         context,
                      //         title: 'Conform Ride'.tr,
                      //         btnHeight: 45,
                      //         btnWidthRatio: 0.8,
                      //         btnColor: ConstantColors.primary,
                      //         txtColor: Colors.white,
                      //         onPress: () async {
                      //           showDialog(
                      //             barrierColor: Colors.black26,
                      //             context: context,
                      //             builder: (context) {
                      //               return CustomAlertDialog(
                      //                 title: "Do you want to confirm this ride?",
                      //                 onPressNegative: () {
                      //                   Get.back();
                      //                 },
                      //                 onPressPositive: () {
                      //                   Map<String, dynamic> bodyParams = {
                      //                     'id_ride': rideData!.id.toString(),
                      //                     'id_user': rideData!.idConducteur.toString(),
                      //                     'use_name': rideData!.prenomConducteur.toString(),
                      //                     'car_driver_confirmed': 1,
                      //                     'from_id': Preferences.getInt(Preferences.userId).toString(),
                      //                   };
                      //                   controllerRideDetails.setConformRequest(bodyParams).then((value) {
                      //                     if (value != null) {
                      //                       Get.back();
                      //                       showDialog(
                      //                           context: context,
                      //                           builder: (BuildContext context) {
                      //                             return CustomDialogBox(
                      //                               title: "On ride Successfully",
                      //                               descriptions: "Ride Successfully On ride you can check ride in on ride section.",
                      //                               onPress: () {
                      //                                 Get.back();
                      //                                 controllerDashBoard.onSelectItem(4);
                      //                               },
                      //                               img: Image.asset('assets/images/green_checked.png'),
                      //                             );
                      //                           });
                      //                     }
                      //                   });
                      //                 },
                      //               );
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Visibility(
                        visible: rideData!.statut == "rejected" ? false : true,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 10),
                            child: ButtonThem.buildBorderButton(
                              context,
                              title: 'Cancel Ride'.tr,
                              btnHeight: 45,
                              btnWidthRatio: 0.8,
                              btnColor: Colors.white,
                              txtColor: ConstantColors.primary,
                              btnBorderColor: ConstantColors.primary,
                              onPress: () async {
                                buildShowBottomSheet(context);
                                // showDialog(
                                //   barrierColor: Colors.black26,
                                //   context: context,
                                //   builder: (context) {
                                //     return CustomAlertDialog(
                                //       title: "Do you want to cancel this booking?",
                                //       onPressNegative: () {
                                //         Get.back();
                                //       },
                                //       onPressPositive: () {
                                //         Map<String, String> bodyParams = {
                                //           'id_ride': rideData!.id.toString(),
                                //           'id_user': rideData!.idConducteur.toString(),
                                //           'name': rideData!.prenom.toString(),
                                //           'from_id': Preferences.getInt(Preferences.userId).toString(),
                                //           'user_cat': controllerRideDetails.userModel!.data!.userCat.toString(),
                                //         };
                                //         controllerRideDetails.canceledRide(bodyParams).then((value) {
                                //           Get.back();
                                //           if (value != null) {
                                //             showDialog(
                                //                 context: context,
                                //                 builder: (BuildContext context) {
                                //                   return CustomDialogBox(
                                //                     title: "Cancel Successfully",
                                //                     descriptions: "Ride Successfully cancel you can check ride in canceled section.",
                                //                     onPress: () {
                                //                       Get.back();
                                //                       controllerDashBoard.onSelectItem(4);
                                //                     },
                                //                     img: Image.asset('assets/images/green_checked.png'),
                                //                   );
                                //                 });
                                //           }
                                //         });
                                //       },
                                //     );
                                //   },
                                // );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  final resonController = TextEditingController();

  buildShowBottomSheet(BuildContext context) {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Cancel Trip",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Write a reason for trip cancellation",
                        style: TextStyle(color: Colors.black.withOpacity(0.50)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: resonController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Cancel Trip'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white,
                                onPress: () async {
                                  if (resonController.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title: "Do you want to cancel this booking?",
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_ride': rideData!.id.toString(),
                                              'id_user': rideData!.idConducteur.toString(),
                                              'name': "${rideData!.prenom} ${rideData!.nom}",
                                              'from_id': Preferences.getInt(Preferences.userId).toString(),
                                              'user_cat': controllerRideDetails.userModel!.data!.userCat.toString(),
                                              'reason': resonController.text.toString(),
                                            };
                                            controllerRideDetails.canceledRide(bodyParams).then((value) {
                                              Get.back();
                                              if (value != null) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title: "Cancel Successfully",
                                                        descriptions: "Ride Successfully cancel you can check ride in canceled section.",
                                                        onPress: () {
                                                          Get.back();
                                                          controllerDashBoard.onSelectItem(6);
                                                        },
                                                        img: Image.asset('assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    ShowToastDialog.showToast("Please enter a reason");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                btnBorderColor: ConstantColors.primary,
                                onPress: () async {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  getDirections({required double dLat, required double dLng}) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result;
    debugPrint('Lat ${double.parse(rideData!.latitudeDepart.toString())}');
    debugPrint('Lng ${double.parse(rideData!.longitudeDepart.toString())}');

    if (rideData!.statut == "confirmed") {
      result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey,
        PointLatLng(double.parse(rideData!.latitudeDepart.toString()), double.parse(rideData!.longitudeDepart.toString())),
        PointLatLng(dLat, dLng),
        travelMode: TravelMode.driving,
      );
    } else if (rideData!.statut == "on ride") {
      result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey,
        PointLatLng(dLat, dLng),
        PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
        travelMode: TravelMode.driving,
      );
    } else {
      result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleApiKey,
        PointLatLng(departureLatLong.latitude, departureLatLong.longitude),
        PointLatLng(destinationLatLong.latitude, destinationLatLong.longitude),
        travelMode: TravelMode.driving,
      );
    }

    _markers['Departure'] = Marker(
      markerId: const MarkerId('Departure'),
      infoWindow: const InfoWindow(title: "Departure"),
      position: LatLng(double.parse(rideData!.latitudeDepart.toString()), double.parse(rideData!.longitudeDepart.toString())),
      icon: departureIcon!,
    );

    _markers['Destination'] = Marker(
      markerId: const MarkerId('Destination'),
      infoWindow: const InfoWindow(title: "Destination"),
      position: destinationLatLong,
      icon: destinationIcon!,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: ConstantColors.primary,
      points: polylineCoordinates,
      width: 4,
      geodesic: true,
    );
    polyLines[id] = polyline;
    setState(() {});
  }
}
