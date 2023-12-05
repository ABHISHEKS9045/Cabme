import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/home_controller.dart';
import 'package:cabme/model/driver_model.dart';
import 'package:cabme/model/vehicle_category_model.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/custom_dialog_box.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:cabme/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as get_cord_address;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraPosition _kInitialPosition = const CameraPosition(target: LatLng(22.7196, 75.8577), zoom: 11.0, tilt: 0, bearing: 0);

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final controller = Get.put(HomeController());

  GoogleMapController? _controller;
  final Location currentLocation = Location();

  final Map<String, Marker> _markers = {};

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;

  LatLng? departureLatLong;
  LatLng? destinationLatLong;

  Map<PolylineId, Polyline> polyLines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    setIcons();
    super.initState();
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

    controller.getTaxiData().then((value) {
      if (value != null) {
        if (value.success == "success") {
          for (var element in value.data!) {
            if (element.latitude != null && element.longitude != null && element.latitude!.isNotEmpty && element.longitude!.isNotEmpty && element.statut == "yes") {
              _markers[element.id.toString()] = Marker(
                markerId: MarkerId(element.id.toString()),
                infoWindow: InfoWindow(title: element.prenom.toString(), snippet: "${element.brand},${element.model},${element.numberplate}"),
                position: LatLng(double.parse(element.latitude ?? "0.0"), double.parse(element.longitude ?? "0.0")),
                icon: taxiIcon!,
              );
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentLocation(bool isDepartureSet) async {
    if (isDepartureSet) {
      LocationData location = await currentLocation.getLocation();
      List<get_cord_address.Placemark> placeMarks = await get_cord_address.placemarkFromCoordinates(location.latitude ?? 0.0, location.longitude ?? 0.0);

      final address = (placeMarks.first.subLocality!.isEmpty ? '' : "${placeMarks.first.subLocality}, ") +
          (placeMarks.first.street!.isEmpty ? '' : "${placeMarks.first.street}, ") +
          (placeMarks.first.name!.isEmpty ? '' : "${placeMarks.first.name}, ") +
          (placeMarks.first.subAdministrativeArea!.isEmpty ? '' : "${placeMarks.first.subAdministrativeArea}, ") +
          (placeMarks.first.administrativeArea!.isEmpty ? '' : "${placeMarks.first.administrativeArea}, ") +
          (placeMarks.first.country!.isEmpty ? '' : "${placeMarks.first.country}, ") +
          (placeMarks.first.postalCode!.isEmpty ? '' : "${placeMarks.first.postalCode}, ");
      departureController.text = address;
      setState(() {
        setDepartureMarker(LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Get.to(PaymentSelectionScreen());
      //   },
      // ),
      backgroundColor: ConstantColors.background,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(
              top: 190.0,
            ),
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (GoogleMapController controller) async {
              _controller = controller;
              LocationData location = await currentLocation.getLocation();
              _controller!.moveCamera(CameraUpdate.newLatLngZoom(LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0), 14));
            },
            polylines: Set<Polyline>.of(polyLines.values),
            myLocationEnabled: true,
            markers: _markers.values.toSet(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ElevatedButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      "assets/icons/ic_side_menu.png",
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/ic_pic_drop_location.png",
                              height: 85,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await controller.placeSelectAPI(context).then((value) {
                                                if (value != null) {
                                                  departureController.text = value.result.formattedAddress.toString();
                                                  setDepartureMarker(LatLng(value.result.geometry!.location.lat, value.result.geometry!.location.lng));
                                                }
                                              });
                                            },
                                            child: buildTextField(
                                              title: "Departure",
                                              textController: departureController,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            getCurrentLocation(true);
                                          },
                                          autofocus: false,
                                          icon: const Icon(
                                            Icons.my_location_outlined,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    InkWell(
                                      onTap: () async {
                                        await controller.placeSelectAPI(context).then((value) {
                                          if (value != null) {
                                            destinationController.text = value.result.formattedAddress.toString();
                                            setDestinationMarker(LatLng(value.result.geometry!.location.lat, value.result.geometry!.location.lng));
                                          }
                                        });
                                      },
                                      child: buildTextField(
                                        title: "Where do you want to go ?",
                                        textController: destinationController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  setDepartureMarker(LatLng departure) {
    setState(() {
      _markers.remove("Departure");
      _markers['Departure'] = Marker(
        markerId: const MarkerId('Departure'),
        infoWindow: const InfoWindow(title: "Departure"),
        position: departure,
        icon: departureIcon!,
      );
      departureLatLong = departure;
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(departure.latitude, departure.longitude), zoom: 14)));

      // _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(departure.latitude, departure.longitude), zoom: 18)));
      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        conformationBottomSheet(context);
      }
    });
  }

  setDestinationMarker(LatLng destination) {
    setState(() {
      _markers['Destination'] = Marker(
        markerId: const MarkerId('Destination'),
        infoWindow: const InfoWindow(title: "Destination"),
        position: destination,
        icon: destinationIcon!,
      );
      destinationLatLong = destination;

      if (departureLatLong != null && destinationLatLong != null) {
        getDirections();
        // tripOptionBottomSheet(context);
        conformationBottomSheet(context);
        print("getDirections:=======================$getDirections");

      }
    });
  }

  Widget buildTextField({required title, required TextEditingController textController}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabled: false,
        ),
      ),
    );
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constant.kGoogleApiKey,
      PointLatLng(departureLatLong!.latitude, departureLatLong!.longitude),
      PointLatLng(destinationLatLong!.latitude, destinationLatLong!.longitude),
      travelMode: TravelMode.driving,
    );


    if (result.points.isNotEmpty) {



      print("result=================${departureLatLong!.latitude}");
      print("result=================${departureLatLong!.longitude}");
      print("result=================${destinationLatLong!.latitude}");
      print("result=================${destinationLatLong!.longitude}");
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

  conformationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
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
                        title: "Back",
                        btnColor: ConstantColors.yellow,
                        txtColor: Colors.black, onPress: () {
                          // tripOptionBottomSheet(context);
                          Get.back();
                        }),
                  ),
                  Expanded(
                    child: ButtonThem.buildButton(context, btnHeight: 40, title: "Continue".tr, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () async {
                      await controller.getDurationDistance(departureLatLong!, destinationLatLong!).then((durationValue) async {
                        print("durationValue===========$durationValue");
                        print("durationValue===========$departureLatLong");
                        print("durationValue===========$destinationLatLong");
                        if (durationValue != null) {



                          await controller.getUserPendingPayment().then((value) async {
                            if (value != null) {
                              if (value['success'] == "success") {
                                print("value===========$value");


                                if (value['data']['amount'] != 0) {
                                  _pendingPaymentDialog(context);
                                } else {
                                  if (Constant.distanceUnit == "KM") {

                                    controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1000.00;
                                    print("distanceUnit===========${controller.distance.value}");
                                  } else {
                                    controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1609.34;
                                  }
                                  // controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'];
                                   controller.duration.value = durationValue['rows'].first['elements'].first['duration']['text'];

                                  tripOptionBottomSheet(context);
                                }
                              } else {
                                if (Constant.distanceUnit == "KM") {

                                  controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1000.00;
                                  tripOptionBottomSheet(context);
                                } else {
                                  controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1609.34;
                                }
                                controller.duration.value = durationValue['rows'].first['elements'].first['duration']['text'];

                                tripOptionBottomSheet(context);
                              }
                            }
                          });
                        }
                      });
                    }),
                  ),
                ],
              ),
            );
          });
        });
  }

  final passengerController = TextEditingController();

  tripOptionBottomSheet(BuildContext context) {
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
                child: Obx(
                      () => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Trip option",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                items: <String>[
                                  'General',
                                  'Business',
                                  'Executive',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ); //DropMenuItem
                                }).toList(),
                                value: controller.tripOptionCategory.value,
                                onChanged: (newValue) {
                                  controller.tripOptionCategory.value = newValue!;
                                },
                                underline: Container(),
                                //OnChange
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passengerController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'How many passenger',
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.addChildList.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: controller.addChildList[index].editingController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    hintText: 'Any children ? Age of child',
                                  ),
                                ),
                              );
                            }),
                        Visibility(
                          visible: controller.addChildList.length < 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.addChildList.length < 3) {
                                      controller.addChildList.add(AddChildModel(editingController: TextEditingController()));
                                    }
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: ConstantColors.primary,
                                        ),
                                        const Text("Add"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
                                    title: "Back",
                                    btnColor: ConstantColors.yellow,
                                    txtColor: Colors.black, onPress: () {
                                      Get.back();
                                    }),
                              ),
                              Expanded(
                                child: ButtonThem.buildButton(context, btnHeight: 40, title: "Book Now".tr, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () async {
                                  if (passengerController.text.isEmpty) {
                                    ShowToastDialog.showToast("Please Enter Passenger");
                                  } else {
                                    await controller.getVehicleCategory().then((value) {
                                      if (value != null) {
                                        if (value.success == "Success") {
                                          Get.back();
                                          List tripPrice = [];
                                          for (int i = 0;
                                              i < value.vehicleData!.length;
                                              i++) {
                                            tripPrice.add(0.0);
                                          }
                                          if (value.vehicleData!.isNotEmpty) {
                                            for (int i = 0;
                                                i < value.vehicleData!.length;
                                                i++) {
                                              if (controller.distance.value >
                                                  value.vehicleData![i]
                                                      .minimumDeliveryChargesWithin!
                                                      .toDouble()) {
                                                tripPrice.add((controller
                                                            .distance.value *
                                                        value.vehicleData![i]
                                                            .deliveryCharges!)
                                                    .toDouble()
                                                    .toStringAsFixed(
                                                        Constant.decimal));
                                              } else {
                                                tripPrice.add(value
                                                    .vehicleData![i]
                                                    .minimumDeliveryCharges!
                                                    .toDouble()
                                                    .toStringAsFixed(
                                                        Constant.decimal));
                                              }
                                            }
                                          }
                                          chooseVehicleBottomSheet(
                                            context,
                                            value,
                                          );
                                        }
                                      }
                                    });
                                  }
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  chooseVehicleBottomSheet(
      BuildContext context,
      VehicleCategoryModel vehicleCategoryModel,
      ) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Choose Your Vehicle Type",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset("assets/icons/ic_distance.png", height: 24, width: 24),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Distance", style: TextStyle(fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                        Text("${controller.distance.value.toStringAsFixed(2)} ${Constant.distanceUnit}")
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: vehicleCategoryModel.vehicleData!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Obx(
                                  () => InkWell(
                                onTap: () {
                                  controller.vehicleData = vehicleCategoryModel.vehicleData![index];
                                  controller.selectedVehicle.value = vehicleCategoryModel.vehicleData![index].id.toString();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: controller.selectedVehicle.value == vehicleCategoryModel.vehicleData![index].id.toString() ? ConstantColors.primary : Colors.black.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: vehicleCategoryModel.vehicleData![index].image.toString(),
                                            fit: BoxFit.fill,
                                            width: 80,
                                            height: 50,
                                            placeholder: (context, url) => Constant.loader(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      vehicleCategoryModel.vehicleData![index].libelle.toString(),
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: controller.selectedVehicle.value == vehicleCategoryModel.vehicleData![index].id.toString() ? Colors.white : Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        controller.duration.value,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: controller.selectedVehicle.value == vehicleCategoryModel.vehicleData![index].id.toString() ? Colors.white : Colors.black,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   "${controller.currency} ${tripPrice[index]} ",
                                                      //   textAlign:
                                                      //       TextAlign.center,
                                                      //   style: TextStyle(
                                                      //     color: controller
                                                      //                 .selectedVehicle
                                                      //                 .value ==
                                                      //             vehicleCategoryModel
                                                      //                 .vehicleData![
                                                      //                     index]
                                                      //                 .id
                                                      //                 .toString()
                                                      //         ? Colors.white
                                                      //         : Colors.black,
                                                      //   ),
                                                      // ),
                                                    ],
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
                              ),
                            );
                          }),
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
                                title: "Back",
                                btnColor: ConstantColors.yellow,
                                txtColor: Colors.black, onPress: () {
                                  Get.back();
                                  tripOptionBottomSheet(context);
                                }),
                          ),
                          Expanded(
                            child: ButtonThem.buildButton(context, btnHeight: 40, title: "Book Now".tr, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () async {
                              if (controller.selectedVehicle.value.isNotEmpty) {
                                double cout = 0.0;

                                if (controller.distance.value > controller.vehicleData!.minimumDeliveryChargesWithin!.toDouble()) {
                                  cout = (controller.distance.value * controller.vehicleData!.deliveryCharges!).toDouble();
                                } else {
                                  cout = controller.vehicleData!.minimumDeliveryCharges!.toDouble();
                                }


                                await controller.getDriverDetails(controller.vehicleData!.id.toString(), departureLatLong!.latitude.toString(), departureLatLong!.longitude.toString()).then((value) {
                                  if (value != null) {
                                    print("<<<<<<<<<<<<<<<<<<<<  available ${controller.vehicleData!.id.toString() }" );

                                    if (value.success == "Success") {
                                      Get.back();

                                      conformDataBottomSheet(context, value, cout);
                                    } else {
                                      // print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Driver not available");
                                      ShowToastDialog.showToast("Driver not available");
                                    }
                                  }
                                });
                              } else {
                                print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Please select Vehicle Type");
                                ShowToastDialog.showToast("Please select Vehicle Type");
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  conformDataBottomSheet(BuildContext context, DriverModel driverModel, double tripPrice) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: driverModel.data![0].photo.toString(),
                                fit: BoxFit.cover,
                                height: 72,
                                width: 72,
                                placeholder: (context, url) => Constant.loader(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  driverModel.data![0].prenom.toString(),
                                  style: TextStyle(fontSize: 16, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: StarRating(size: 18, rating: driverModel.data![0].moyenne!, color: ConstantColors.yellow),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    "Total trips ${driverModel.data![0].totalCompletedRide.toString()}",
                                    style: TextStyle(
                                      color: ConstantColors.subTitleTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Constant.makePhoneCall(driverModel.data![0].toString());
                                },
                                child: ClipOval(
                                  child: Container(
                                    color: ConstantColors.primary,
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.phone,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                    onTap: () {
                                      _favouriteNameDialog(context);
                                    },
                                    child: Image.asset(
                                      'assets/icons/add_fav.png',
                                      height: 32,
                                      width: 32,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _paymentMethodDialog(
                                    context,
                                  );
                                },
                                child: buildDetails(title: controller.paymentMethodType.value, value: 'Payment'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: buildDetails(title: controller.duration.value, value: 'Duration')),
                            // Expanded(child: buildDetails(title: "12km", value: 'Duration')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: buildDetails(title: "${Constant.currency} ${tripPrice.toStringAsFixed(Constant.decimal)}", value: 'Trip Price', txtColor: ConstantColors.primary)),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Opacity(
                            opacity: 0.6,
                            child: Text(
                              "Cab Details:",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            driverModel.data![0].model.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            driverModel.data![0].brand.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            driverModel.data![0].numberplate.toString(),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ButtonThem.buildIconButton(context,
                                iconSize: 16.0,
                                icon: Icons.arrow_back_ios,
                                iconColor: Colors.black,
                                btnHeight: 40,
                                btnWidthRatio: 0.25,
                                title: "Back",
                                btnColor: ConstantColors.yellow,
                                txtColor: Colors.black, onPress: () async {
                                  await controller.getVehicleCategory().then((value) {
                                    if (value != null) {
                                      if (value.success == "Success") {
                                        Get.back();
                                        List tripPrice = [];
                                        for (int i = 0; i < value.vehicleData!.length; i++) {
                                          tripPrice.add(0.0);
                                        }
                                        if (value.vehicleData!.isNotEmpty) {
                                          for (int i = 0; i < value.vehicleData!.length; i++) {
                                            if (controller.distance.value > value.vehicleData![i].minimumDeliveryChargesWithin!.toDouble()) {
                                              tripPrice.add((controller.distance.value * value.vehicleData![i].deliveryCharges!).toDouble().toStringAsFixed(Constant.decimal));
                                            } else {
                                              tripPrice.add(value.vehicleData![i].minimumDeliveryCharges!.toDouble().toStringAsFixed(Constant.decimal));
                                            }
                                          }
                                        }
                                        chooseVehicleBottomSheet(
                                          context,
                                          value,
                                        );
                                      }
                                    }
                                  });
                                }),
                          ),
                          Expanded(
                            child: ButtonThem.buildButton(context, btnHeight: 40, title: "Book now".tr, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () {
                              if (controller.paymentMethodType.value == "Select Method") {
                                ShowToastDialog.showToast("Please select payment method");
                              } else {
                                Map<String, dynamic> bodyParams = {
                                  'user_id': Preferences.getInt(Preferences.userId).toString(),
                                  'lat1': departureLatLong!.latitude.toString(),
                                  'lng1': departureLatLong!.longitude.toString(),
                                  'lat2': destinationLatLong!.latitude.toString(),
                                  'lng2': destinationLatLong!.longitude.toString(),
                                  'cout': tripPrice.toString(),
                                  'distance': controller.distance.toString(),
                                  'distance_unit': Constant.distanceUnit,
                                  'duree': controller.duration.toString(),
                                  'id_conducteur': driverModel.data![0].id.toString(),
                                  'id_payment': controller.paymentMethodId.value,
                                  'depart_name': departureController.text,
                                  'destination_name': destinationController.text,
                                  'place': '',
                                  'number_poeple': passengerController.text,
                                  'image': '',
                                  'image_name': "",
                                  'statut_round': 'no',
                                  'trip_objective': controller.tripOptionCategory.value,
                                  'age_children1': controller.addChildList[0].editingController.text,
                                  'age_children2': controller.addChildList.length == 2 ? controller.addChildList[1].editingController.text : "",
                                  'age_children3': controller.addChildList.length == 3 ? controller.addChildList[2].editingController.text : "",
                                };
                                print("bodyParams===================$bodyParams");


                                controller.bookRide(bodyParams).then((value) {

                                  print("value===================$value");
                                  if (value != null) {
                                    if (value['success'] == "success") {
                                      // Get.back();
                                      departureController.clear();
                                      destinationController.clear();
                                      polyLines = {};
                                      departureLatLong = null;
                                      destinationLatLong = null;
                                      passengerController.clear();
                                      tripPrice = 0.0;
                                      _markers.clear();
                                      controller.clearData();
                                      getDirections();
                                      setIcons();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: "",
                                              descriptions: "Your booking has been sent successfully",
                                              onPress: () {
                                                Get.back();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              img: Image.asset('assets/images/green_checked.png'),
                                            );
                                          });
                                    }
                                  }
                                });
                              }
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  final favouriteNameTextController = TextEditingController();

  _favouriteNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Favourite Name"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldThem.buildTextField(
                  title: 'Favourite name'.tr,
                  labelText: 'Favourite name'.tr,
                  controller: favouriteNameTextController,
                  textInputType: TextInputType.text,
                  contentPadding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text("Cancel")),
                      InkWell(
                          onTap: () {
                            Map<String, String> bodyParams = {
                              'id_user_app': Preferences.getInt(Preferences.userId).toString(),
                              'lat1': departureLatLong!.latitude.toString(),
                              'lng1': departureLatLong!.longitude.toString(),
                              'lat2': destinationLatLong!.latitude.toString(),
                              'lng2': destinationLatLong!.longitude.toString(),
                              'distance': controller.distance.value.toString(),
                              'distance_unit': Constant.distanceUnit,
                              'depart_name': departureController.text,
                              'destination_name': destinationController.text,
                              'fav_name': favouriteNameTextController.text,
                            };
                            controller.setFavouriteRide(bodyParams).then((value) {
                              if (value['success'] == "Success") {
                                Get.back();
                              } else {
                                ShowToastDialog.showToast(value['error']);
                              }
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Ok"),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  _pendingPaymentDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Cab me"),
      content: const Text("You have pending payments. Please complete payment before book new trip."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _paymentMethodDialog(
      BuildContext context,
      ) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Select Payment Method1"),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Visibility(
                      visible: controller.paymentSettingModel.value.cash!.isEnabled == "true" ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.cash.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.cash.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "Cash",
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId = controller.paymentSettingModel.value.cash!.idPaymentMethod.toString().obs;
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.wallet.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.wallet.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "Wallet",
                            groupValue: controller.paymentMethodType.value,
                            onChanged: (String? value) {
                              controller.stripe = false.obs;
                              controller.wallet = true.obs;
                              controller.cash = false.obs;
                              controller.razorPay = false.obs;
                              controller.payTm = false.obs;
                              controller.paypal = false.obs;
                              controller.payStack = false.obs;
                              controller.flutterWave = false.obs;
                              controller.mercadoPago = false.obs;
                              controller.payFast = false.obs;
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId = controller.paymentSettingModel.value.myWallet!.idPaymentMethod.toString().obs;
                              Get.back();
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
                                const Text("Wallet"),
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.stripe.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.stripe.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "Stripe",
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId = controller.paymentSettingModel.value.strip!.idPaymentMethod.toString().obs;
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.payStack.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.payStack.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "PayStack",
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId = controller.paymentSettingModel.value.payStack!.idPaymentMethod.toString().obs;
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.flutterWave.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.flutterWave.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "FlutterWave",
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId.value = controller.paymentSettingModel.value.flutterWave!.idPaymentMethod.toString();
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
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
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId.value = controller.paymentSettingModel.value.razorPay!.idPaymentMethod.toString();
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.payFast.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.payFast.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "PayFast",
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId.value = controller.paymentSettingModel.value.payFast!.idPaymentMethod.toString();
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
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
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId.value = controller.paymentSettingModel.value.paytm!.idPaymentMethod.toString();
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: controller.mercadoPago.value ? 0 : 2,
                          child: RadioListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: controller.mercadoPago.value ? ConstantColors.primary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: "MercadoPago",
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId.value = controller.paymentSettingModel.value.mercadopago!.idPaymentMethod.toString();
                              Get.back();
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
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
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
                            groupValue: controller.paymentMethodType.value,
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
                              controller.paymentMethodType.value = value!;
                              controller.paymentMethodId.value = controller.paymentSettingModel.value.payPal!.idPaymentMethod.toString();
                              Get.back();
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
            );
          });
        });
  }

  // _paymentMethodDialog(BuildContext context, List<PaymentMethodData>? data) {
  //   return showModalBottomSheet(
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(15), topLeft: Radius.circular(15))),
  //       context: context,
  //       isScrollControlled: true,
  //       isDismissible: false,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Text("Select Payment Method1"),
  //                 Divider(
  //                   color: Colors.grey.shade700,
  //                 ),
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: data!.length,
  //                   itemBuilder: (context, index) {
  //                     return InkWell(
  //                       onTap: () {
  //                         controller.paymentMethodData = data[index];
  //                         controller.paymentMethodType.value =
  //                             data[index].libelle.toString();
  //                         Get.back();
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Row(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(
  //                                   vertical: 8, horizontal: 5),
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.blueGrey.shade50,
  //                                   borderRadius: BorderRadius.circular(8),
  //                                 ),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       vertical: 4.0, horizontal: 10),
  //                                   child: SizedBox(
  //                                     width: 80,
  //                                     height: 35,
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                           vertical: 6.0),
  //                                       child: CachedNetworkImage(
  //                                         imageUrl: data[index].image!,
  //                                         placeholder: (context, url) =>
  //                                             const CircularProgressIndicator(),
  //                                         errorWidget: (context, url, error) =>
  //                                             const Icon(Icons.error),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10),
  //                               child: Text(
  //                                 data[index].libelle.toString(),
  //                                 style: const TextStyle(color: Colors.black),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  buildDetails({title, value, Color txtColor = Colors.black}) {
    return Container(
      height: 110,
      decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.9,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: txtColor, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
