import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/screen/laporan/lap_rekap_penjualan.dart';
import 'package:siscom_pos/screen/laporan/lap_ringkasan_penjualan.dart';
import 'package:siscom_pos/screen/pelanggan/detail_pelanggan_view.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/detail_stock_opname.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class LaporanMainView extends StatefulWidget {
  @override
  _LaporanMainViewState createState() => _LaporanMainViewState();
}

class _LaporanMainViewState extends State<LaporanMainView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // var controller = Get.put(ListPelangganViewController());

  @override
  void initState() {
    // controller.startLoad();
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
                    height: Utility.medium + Utility.medium,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(LaporanRingkasanPenjualan(),
                          duration: Duration(milliseconds: 300),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Icon(Iconsax.document_text),
                          ),
                          Expanded(
                            flex: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Ringkasan Penjualan",
                                style: TextStyle(
                                    fontSize: Utility.medium,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Icon(Iconsax.arrow_right_3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Divider(),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(LaporanRekapPenjualan(),
                          duration: Duration(milliseconds: 300),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Icon(Iconsax.document_filter),
                          ),
                          Expanded(
                            flex: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Rekap Penjualan",
                                style: TextStyle(
                                    fontSize: Utility.medium,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Icon(Iconsax.arrow_right_3),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
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
                  "Laporan",
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
