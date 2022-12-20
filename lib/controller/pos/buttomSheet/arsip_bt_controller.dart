import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class ArsipButtomSheetController extends BaseController
    with GetSingleTickerProviderStateMixin {
  var dashboardController = Get.put(DashbardController());
  var bottomSheetPosController = Get.put(BottomSheetPos());

  AnimationController? animasiController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animasiController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      animationBehavior: AnimationBehavior.normal,
    );
  }

  void checkDetailTransaksi(pk) {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'key_faktur': '$pk',
    };
    var connect = Api.connectionApi("post", body, "get_detail_barang_arsip");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        if (data.isNotEmpty) {
          detailArsipBarang(data);
        } else {
          UtilsAlert.showToast("Barang tidak tersedia");
          bottomSheetPosController.validasiSebelumAksi(
              "Hapus Faktur dan detail pembelian",
              "Yakin hapus faktur dan detail pembelian ini ?",
              "",
              "hapus_faktur",
              pk);
        }
      } else {
        UtilsAlert.showToast("Terjadi kesalahan, check koneksi anda");
      }
    });
  }

  void detailArsipBarang(data) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        transitionAnimationController: animasiController,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Utility.medium,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Detail Transaksi",
                                style: TextStyle(
                                    color: Utility.grey900,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                    onTap: () => Get.back(),
                                    child: Icon(Iconsax.close_circle)),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Utility.medium,
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Utility.greyLight50,
                                    borderRadius: Utility.borderStyle1),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 16, bottom: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${data[0]['NOMOR']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Utility.semiMedium,
                                              color: Utility.grey900),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${Utility.convertDate('${data[0]["TANGGAL"]}')}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Utility.grey900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Utility.medium,
                              ),
                              ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    var namaBarang = data[index]['nama_barang'];
                                    var jumlahBeli = data[index]['QTY'];
                                    var harga = data[index]['HARGA'];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 60,
                                              child: Text(
                                                "$namaBarang  x$jumlahBeli",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Utility.normal),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 40,
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    "${currencyFormatter.format(harga)}"),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    );
                                  }),
                              SizedBox(
                                height: Utility.medium,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Utility.greyLight50,
                                    borderRadius: Utility.borderStyle1),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 16, bottom: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 30,
                                        child: Text(
                                          "Pelanggan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Utility.normal,
                                              color: Utility.nonAktif),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 70,
                                        child: Text(
                                          "${data[0]['nama_pelanggan']}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Utility.grey900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Utility.greyLight50,
                                    borderRadius: Utility.borderStyle1),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 16, bottom: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 30,
                                        child: Text(
                                          "Sales",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Utility.normal,
                                              color: Utility.nonAktif),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 70,
                                        child: Text(
                                          "${data[0]['nama_sales']}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Utility.grey900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Utility.normal,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Utility.greyLight100,
                                        borderRadius: Utility.borderStyle1),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        "Unpaid",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 6.0),
                                    decoration: BoxDecoration(
                                        color: Utility.greyLight100,
                                        borderRadius: Utility.borderStyle1),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        "Valid",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 6.0),
                                    decoration: BoxDecoration(
                                        color: Utility.greyLight100,
                                        borderRadius: Utility.borderStyle1),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        "Accounting",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 6,
                      ),
                      Button3(
                        textBtn: "Hapus Pesanan",
                        colorSideborder: Utility.primaryDefault,
                        overlayColor: Color.fromARGB(255, 247, 157, 150),
                        colorText: Utility.primaryDefault,
                        onTap: () {
                          bottomSheetPosController.validasiSebelumAksi(
                              "Hapus Faktur dan detail pembelian",
                              "Yakin hapus faktur dan detail pembelian ini ?",
                              "",
                              "hapus_faktur",
                              data[0]['PK']);
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Button3(
                        textBtn: "Void",
                        colorSideborder: Utility.primaryDefault,
                        overlayColor: Color.fromARGB(255, 247, 157, 150),
                        colorText: Utility.primaryDefault,
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Button1(
                        textBtn: "Lanjutkan Transaksi",
                        colorBtn: Utility.primaryDefault,
                        onTap: () {
                          dashboardController
                              .gantiLanjutkanArsipFaktur(data[0]['NOMOR']);
                        },
                      ),
                      SizedBox(
                        height: Utility.medium,
                      ),
                    ]));
          });
        });
  }
}
