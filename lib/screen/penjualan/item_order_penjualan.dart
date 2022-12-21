import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/buat_order_penjualan.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class ItemOrderPenjualan extends StatefulWidget {
  @override
  _ItemOrderPenjualanState createState() => _ItemOrderPenjualanState();
}

class _ItemOrderPenjualanState extends State<ItemOrderPenjualan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(ItemOrderPenjualanController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());
  var globalCt = Get.put(GlobalController());

  @override
  void initState() {
    controller.getDataBarang();
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
          backgroundColor: Utility.baseColor2,
          appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 2,
              flexibleSpace: AppbarMenu1(
                title: "Buat Order Penjualan",
                colorTitle: Utility.primaryDefault,
                colorIcon: Utility.primaryDefault,
                icon: 1,
                onTap: () {
                  controller.showDialog();
                },
              )),
          body: WillPopScope(
            onWillPop: () async {
              controller.showDialog();
              return controller.statusBack.value;
            },
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    CardCustom(
                      colorBg: Colors.white,
                      radiusBorder: Utility.borderStyle1,
                      widgetCardCustom: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.statusInformasiSo.value =
                                    !controller.statusInformasiSo.value;
                                controller.statusInformasiSo.refresh();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 90,
                                    child: Text(
                                      "INFORMASI SO",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: !controller.statusInformasiSo.value
                                        ? Icon(
                                            Iconsax.arrow_right_3,
                                            size: 18,
                                          )
                                        : Icon(
                                            Iconsax.arrow_down_1,
                                            size: 18,
                                          ),
                                  )
                                ],
                              ),
                            ),
                            !controller.statusInformasiSo.value
                                ? SizedBox()
                                : SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: Utility.medium,
                                        ),
                                        lineHeaderInfo()
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.listBarang.isNotEmpty) {
                          globalCt.buttomSheet1(controller.listBarang,
                              "Pilih Barang", "pilih_barang_so_penjualan", "");
                        } else {
                          controller.getDataBarang();
                        }
                      },
                      child: CardCustom(
                        colorBg: Colors.white,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 90,
                                child: Text(
                                  "Pilih Barang",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Icon(
                                  Iconsax.arrow_down_1,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget lineHeaderInfo() {
    return CardCustomShadow(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Padding(
        padding: EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nomor SO",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${Utility.convertNoFaktur('${dashboardPenjualanCt.nomorSoSelected.value}')}",
                          style: TextStyle(color: Utility.grey600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 1.5,
                        color: Color.fromARGB(24, 0, 22, 103),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 58,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cabang",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${sidebarCt.cabangNameSelectedSide.value}",
                            style: TextStyle(
                              color: Utility.grey600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sales",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${dashboardPenjualanCt.selectedNameSales.value}",
                          style: TextStyle(color: Utility.grey600),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 1.5,
                        color: Color.fromARGB(24, 0, 22, 103),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 58,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pelanggan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${dashboardPenjualanCt.selectedNamePelanggan.value}",
                            style: TextStyle(
                              color: Utility.grey600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
