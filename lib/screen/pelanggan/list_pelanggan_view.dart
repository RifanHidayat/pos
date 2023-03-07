import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/detail_stock_opname.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class ListPelangganView extends StatefulWidget {
  @override
  _ListPelangganViewState createState() => _ListPelangganViewState();
}

class _ListPelangganViewState extends State<ListPelangganView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(ListPelangganViewController());

  @override
  void initState() {
    controller.startLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.startLoad();
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
              children: [
                header(),
                SizedBox(
                  height: Utility.medium,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SearchApp(
                    onTap: (value) {
                      print(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Flexible(
                //     child: RefreshIndicator(
                //         color: Utility.primaryDefault,
                //         onRefresh: refreshData,
                //         child: Padding(
                //           padding: const EdgeInsets.only(left: 16, right: 16),
                //           child: listStokOpnameView(),
                //         )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Utility.baseColor2,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(Get.context!).size.width,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () => _scaffoldKey.currentState!.openDrawer(),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.menu_14,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 60,
              child: Center(
                child: Text(
                  "Pelanggan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Utility.medium),
                ),
              )),
          Expanded(flex: 20, child: SizedBox()),
        ],
      ),
    );
  }
}
