import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:siscom_pos/utils/utility.dart';

class UtilsAlert {
  static showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 12);
  }

  static showLoadingIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Utility.primaryDefault,
                          ),
                          padding: EdgeInsets.all(8)),
                      Padding(
                          child: Text(
                            'Tunggu Sebentar …',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.all(8))
                    ],
                  )
                ]));
      },
    );
  }

  static loadingSimpanData(BuildContext context, text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 20,
                        child: Padding(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Utility.primaryDefault,
                            ),
                            padding: EdgeInsets.all(8)),
                      ),
                      Expanded(
                        flex: 80,
                        child: Padding(
                            child: Text(
                              text,
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            padding: EdgeInsets.all(8)),
                      )
                    ],
                  )
                ]));
      },
    );
  }

  static shimmerMenuDashboard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                        height: 30,
                        width: 100,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                        height: 30,
                        width: 100,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                )
              ]),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 5, top: 5),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 5, top: 5),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 5, top: 5),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 5, top: 5),
                    child: SizedBox(
                        height: 50,
                        child: Card(child: ListTile(title: Text('')))),
                  ),
                )
              ]),
            ],
          )),
    );
  }

  static shimmerBannerDashboard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SizedBox(
            height: 100,
            child: Card(child: ListTile(title: Text(''))),
          )),
    );
  }
}
