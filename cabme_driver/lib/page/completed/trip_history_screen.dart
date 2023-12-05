import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/model/ride_model.dart';
import 'package:cabme_driver/page/chats_screen/conversation_screen.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripHistoryScreen extends StatefulWidget {
  final RideData data;

  const TripHistoryScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  double getTotalAmount() {
    if (Constant.taxType == "Percentage") {
      widget.data.tax = Constant.taxValue != 0
          ? (double.parse(widget.data.montant.toString()) -
                  widget.data.discount!) *
              double.parse(Constant.taxValue.toString()) /
              100
          : 0.0;
    } else {
      widget.data.tax = Constant.taxValue != 0
          ? double.parse(Constant.taxValue.toString())
          : 0.0;
    }

    return (double.parse(widget.data.montant.toString()) -
            widget.data.discount!) +
        widget.data.tipAmount! +
        widget.data.tax!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.background,
      appBar: AppBar(
          backgroundColor: ConstantColors.background,
          elevation: 0,
          centerTitle: true,
          title:
              const Text("Trip Details", style: TextStyle(color: Colors.black)),
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
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/ic_pic_drop_location.png",
                          height: 60,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.data.departName.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const Divider(),
                                Text(widget.data.destinationName.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "completed".tr,
                          style: TextStyle(color: ConstantColors.primary),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/passenger.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              " ${widget.data.numberPoeple.toString()}",
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
                                          "${Constant.currency}${widget.data.montant!.toDouble().toStringAsFixed(Constant.decimal)}",
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/ic_distance.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              "${widget.data.distance.toString()} ${widget.data.distanceUnit}",
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/time.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              widget.data.duree.toString(),
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
                              imageUrl: widget.data.photoPath.toString(),
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
                                      "${widget.data.prenomConducteur.toString()} ${widget.data.nomConducteur.toString()}",
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600)),
                                  StarRating(
                                      size: 18,
                                      rating: widget.data.moyenne!,
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
                                  InkWell(
                                      onTap: () {
                                        Get.to(ConversationScreen(),
                                            arguments: {
                                              'receiverId':
                                                  widget.data.idConducteur,
                                              'orderId': widget.data.id,
                                              'receiverName':
                                                  "${widget.data.prenomConducteur} ${widget.data.nomConducteur}",
                                              'receiverPhoto':
                                                  widget.data.photoPath
                                            });
                                      },
                                      child: Image.asset(
                                        'assets/icons/chat_icon.png',
                                        height: 36,
                                        width: 36,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: InkWell(
                                        onTap: () {
                                          Constant.makePhoneCall(widget
                                              .data.driverPhone
                                              .toString());
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
                                child: Text(widget.data.dateRetour.toString(),
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
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.subTitleTextColor,
                                fontWeight: FontWeight.w600),
                          )),
                          Text(
                              '${Constant.currency} ${widget.data.montant!.toDouble().toStringAsFixed(Constant.decimal)}',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.titleTextColor,
                                  fontWeight: FontWeight.w800)),
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
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.subTitleTextColor,
                                fontWeight: FontWeight.w600),
                          )),
                          Text(
                              '${Constant.currency} ${widget.data.discount!.toDouble().toStringAsFixed(Constant.decimal)}',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.titleTextColor,
                                  fontWeight: FontWeight.w800)),
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
                            "${Constant.taxName} ${Constant.taxType == "Percentage" ? "(${Constant.taxValue}%)" : ""}",
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.subTitleTextColor,
                                fontWeight: FontWeight.w600),
                          )),
                          Text(
                              '${Constant.currency} ${widget.data.tax!.toDouble().toStringAsFixed(Constant.decimal)}',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.titleTextColor,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Visibility(
                        visible: widget.data.tipAmount!.toDouble() == 0.0
                            ? false
                            : true,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Divider(
                                color: Colors.black.withOpacity(0.40),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Driver Tip",
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: ConstantColors.subTitleTextColor,
                                      fontWeight: FontWeight.w600),
                                )),
                                Text(
                                    '${Constant.currency} ${widget.data.tipAmount!.toDouble().toStringAsFixed(Constant.decimal)}',
                                    style: TextStyle(
                                        letterSpacing: 1.0,
                                        color: ConstantColors.titleTextColor,
                                        fontWeight: FontWeight.w800)),
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
                        children: [
                          Expanded(
                              child: Text(
                            "Total",
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.titleTextColor,
                                fontWeight: FontWeight.w600),
                          )),
                          Text(
                              '${Constant.currency} ${getTotalAmount().toStringAsFixed(2)}',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.primary,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
