import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/screen/penjualan/buat_order_penjualan.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class DashboardPenjualan extends StatefulWidget {
  @override
  _DashboardPenjualanState createState() => _DashboardPenjualanState();
}

class _DashboardPenjualanState extends State<DashboardPenjualan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(DashbardPenjualanController());

  @override
  void initState() {
    controller.loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.loadData();
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
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  listMenuTop(),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  screenCaridanFilter(),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Flexible(
                      child: RefreshIndicator(
                    color: Utility.primaryDefault,
                    onRefresh: refreshData,
                    child: controller.screenAktif.value == 1
                        ? screenOrderPenjualan()
                        : SizedBox(),
                  ))
                ],
              ),
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
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () => _scaffoldKey.currentState!.openDrawer(),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16.0),
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
                  "Penjualan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Utility.medium),
                ),
              )),
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () => Get.to(BuatOrderPenjualan(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeftWithFade),
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Iconsax.add_square,
                  color: Utility.primaryDefault,
                ),
              ),
            ),
          ),
          // Expanded(
          //   flex: 10,
          //   child: Stack(
          //     children: [
          //       InkWell(
          //           onTap: () {},
          //           child: Container(
          //               alignment: Alignment.center,
          //               margin: EdgeInsets.only(bottom: 2.0),
          //               child: Icon(Iconsax.menu_board))),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 2.0),
          //         child: Text(
          //           "${controller.jumlahArsipOrderPenjualan.value}",
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               color: Colors.red,
          //               fontSize: Utility.medium),
          //         ),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget screenCaridanFilter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: pencarianData(),
          ),
        ),
        Expanded(
          flex: 20,
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: CardCustom(
                colorBg: Colors.white,
                radiusBorder: Utility.borderStyle1,
                widgetCardCustom: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Icon(
                      Iconsax.setting_4,
                      color: Utility.greyDark,
                    ),
                  ),
                ),
              )),
        )
      ],
    );
  }

  Widget pencarianData() {
    return CardCustom(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Iconsax.search_normal_1,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 80,
                      child: TextField(
                        controller: controller.cari.value,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Cari"),
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontSize: 14.0, height: 1.5, color: Colors.black),
                        onSubmitted: (value) {},
                      ),
                    ),
                    // !controller.statusCari.value
                    //     ? SizedBox()
                    //     : Expanded(
                    //         flex: 20,
                    //         child: IconButton(
                    //           icon: Icon(
                    //             Iconsax.close_circle,
                    //             color: Colors.red,
                    //           ),
                    //           onPressed: () {

                    //           },
                    //         ),
                    //       )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listMenuTop() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.menuShowonTop.value.length,
          itemBuilder: (context, index) {
            var id = controller.menuShowonTop.value[index]['id'];
            var nama_menu = controller.menuShowonTop.value[index]['nama_menu'];
            var status = controller.menuShowonTop.value[index]['status'];
            return Container(
              margin: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: status == true
                        ? Utility.primaryDefault
                        : Utility.greyLight50,
                    width: 3.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18.0, top: 8.0, bottom: 8.0),
                child: Center(
                    child: Text(
                  "$nama_menu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
            );
          }),
    );
  }

  Widget screenOrderPenjualan() {
    return controller.dataAllSohd.isEmpty
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Utility.primaryDefault,
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Text(
                  "Memuat data...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        : ListView.builder(
            physics: controller.dataAllSohd.length <= 10
                ? AlwaysScrollableScrollPhysics()
                : BouncingScrollPhysics(),
            itemCount: controller.dataAllSohd.length,
            itemBuilder: (context, index) {
              var nomor = controller.dataAllSohd[index]['NOMOR'];
              var tanggal = controller.dataAllSohd[index]['TANGGAL'];
              var ipStatus = controller.dataAllSohd[index]['IP'];
              var hargaNet = controller.dataAllSohd[index]['HRGNET'] == null ||
                      controller.dataAllSohd[index]['HRGNET'] == ""
                  ? 0
                  : controller.dataAllSohd[index]['HRGNET'];
              return Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => controller
                          .lanjutkanSoPenjualan(controller.dataAllSohd[index]),
                      child: IntrinsicHeight(
                          child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: Utility.borderStyle1,
                              color: ipStatus == ""
                                  ? Colors.white
                                  : Utility.greyLight300,
                            ),
                            child: ipStatus == ""
                                ? SizedBox()
                                : Center(
                                    child: Icon(
                                      Iconsax.lock,
                                      color: Utility.primaryDefault,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${Utility.convertNoFaktur(nomor)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Utility.medium),
                                      ),
                                      Text(
                                        "${Utility.convertDate(tanggal)}",
                                        style:
                                            TextStyle(color: Utility.nonAktif),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Text(
                                    "${controller.currencyFormatter.format(hargaNet)}",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                    Divider(),
                    SizedBox(
                      height: Utility.small,
                    ),
                  ],
                ),
              );
            });
  }
}