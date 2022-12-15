import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/utility.dart';

class ListPenjualan extends StatefulWidget {
  @override
  _ListPenjualanState createState() => _ListPenjualanState();
}

class _ListPenjualanState extends State<ListPenjualan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Sidebar(),
          backgroundColor: Utility.baseColor2,
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                SizedBox(
                  height: Utility.medium,
                ),
                Center(
                  child: Text("Halaman penjualan"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _scaffoldKey.currentState!.openDrawer(),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Iconsax.menu_14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
