import 'package:cabme/constant/constant.dart';
import 'package:cabme/controller/new_ride_controller.dart';
import 'package:cabme/model/ride_model.dart';
import 'package:cabme/page/route_view_screen/route_view_screen.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

class NewRideScreen extends StatelessWidget {
  const NewRideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NewRideController>(
      init: NewRideController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getNewRide(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: controller.isLoading.value
                    ? Constant.loader()
                    : controller.rideList.isEmpty
                        ? Constant.emptyView(
                            context,
                            "You have not booked any trip.\n Please book a cab now",
                            true)
                        : ListView.builder(
                            itemCount: controller.rideList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return newRideWidgets(
                                  context, controller.rideList[index]);
                            }),
              ),
            ));
      },
    );
  }

  Widget newRideWidgets(BuildContext context, RideData data) {
    return InkWell(
      onTap: () {
        var argumentData = {'type': 'new'.tr, 'data': data};
        Get.to(const RouteViewScreen(), arguments: argumentData);
      },
      child: Padding(
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
                              data.departName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(),
                            Text(
                              data.destinationName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'new'.tr,
                      style: TextStyle(color: ConstantColors.primary),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Padding(
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/passenger.png',
                                      height: 22,
                                      width: 22,
                                      color: ConstantColors.yellow,
                                    ),
                                    Text(" ${data.numberPoeple.toString()}",
                                        //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black54)),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                                      "${Constant.currency} ${data.montant!.toStringAsFixed(Constant.decimal)}",
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                                      child: Text(
                                          "${data.distance.toString()} ${data.distanceUnit}",
                                          //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54)),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                                      child: TextScroll(data.duree.toString(),
                                          mode: TextScrollMode.bouncing,
                                          pauseBetween:
                                              const Duration(seconds: 2),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black54)),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: data.photoPath.toString(),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Constant.loader(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${data.prenomConducteur} ${data.nomConducteur}",
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600)),
                              StarRating(
                                  size: 18,
                                  rating: data.moyenne!,
                                  color: ConstantColors.yellow),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: InkWell(
                                    onTap: () {
                                      Constant.makePhoneCall(
                                          data.driverPhone.toString());
                                    },
                                    child: Image.asset(
                                      'assets/icons/call_icon.png',
                                      height: 36,
                                      width: 36,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(data.dateRetour.toString(),
                                style: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w600)),
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
    );
  }
}
