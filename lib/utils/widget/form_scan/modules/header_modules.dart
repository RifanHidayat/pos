import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controller/pos/dashboard_controller.dart';
import '../../../../screen/pos/rincian_pemesanan.dart';
import '../../../toast.dart';
import '../../../utility.dart';

class Header {
  static var dashboardCt = Get.put(DashbardController());

  static form() {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity'),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      aksiKurangQty(context);
                    },
                    child: Container(
                        height: 25,
                        width: 30,
                        padding: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Utility.primaryDefault, width: 1)),
                        child: Icon(
                          Iconsax.minus,
                          color: Utility.primaryDefault,
                        )),
                  ),
                  Obx(() => Text(dashboardCt.jumlahPesan.value.text)),
                  InkWell(
                    onTap: () {
                      aksiTambahQty(context);
                    },
                    child: Container(
                        height: 25,
                        width: 30,
                        padding: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Utility.primaryDefault, width: 1)),
                        child: Icon(
                          Iconsax.add,
                          color: Utility.primaryDefault,
                          size: 20,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  static void aksiKurangQty(content) {
    int vld1 = int.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();
    int vld3 = vld2 - 1;
    if (vld3 < 0) {
      UtilsAlert.showToast("Quantity tidak valid");
    } else {
      var convertHrgjual =
          dashboardCt.hargaJualPesanBarang.value.text.split(',');
      var filter1 = convertHrgjual[0].replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      var hrgJualEdit = double.parse(filter3);
      double hargaProduk = hrgJualEdit;
      int hitungJumlahPesan = int.parse('$vld3');
      // dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toStringAsFixed(2);
      dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toString();
      var hasill = hargaProduk * hitungJumlahPesan;
      // dashboardCt.totalPesan.value = hasill.toPrecision(2);
      // dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
      dashboardCt.totalPesan.value = hasill;
      dashboardCt.totalPesanNoEdit.value = hasill;
      dashboardCt.totalPesan.refresh();
      dashboardCt.jumlahPesan.refresh();
      if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
          dashboardCt.hargaDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  static void aksiTambahQty(context) {
    int vld1 = int.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1;

    var convertHrgjual = dashboardCt.hargaJualPesanBarang.value.text.split(',');
    var filter1 = convertHrgjual[0].replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var hrgJualEdit = double.parse(filter3);
    double hargaProduk = hrgJualEdit;
    int hitungJumlahPesan = vld2 + 1;
    // dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toStringAsFixed(2);
    dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toString();
    var hasill = hargaProduk * hitungJumlahPesan;
    // dashboardCt.totalPesan.value = hasill.toPrecision(2);
    // dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
    dashboardCt.totalPesan.value = hasill;
    dashboardCt.totalPesanNoEdit.value = hasill;
    dashboardCt.totalPesan.refresh();
    debugPrint('dashboardCt.totalPesan.value  ${dashboardCt.totalPesan.value}');
    dashboardCt.jumlahPesan.refresh();
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
        dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  static void aksiJikaAdaDiskon() {
    var totalPesan = dashboardCt.totalPesan.value;
    var flt1 =
        dashboardCt.hargaDiskonPesanBarang.value.text.replaceAll(".", "");
    var flt2 = flt1.replaceAll(",", "");
    var hitung =
        double.parse(flt2) * int.parse(dashboardCt.jumlahPesan.value.text);
    var hitungFinal = dashboardCt.totalPesan.value - hitung;
    dashboardCt.totalPesan.value = hitungFinal;
    dashboardCt.totalPesan.refresh();
  }

  void clearInputanDiskon() {
    dashboardCt.totalPesan.value = dashboardCt.totalPesanNoEdit.value;
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    dashboardCt.totalPesan.refresh();
  }

  void changeDiskonHeaderDataLocal() {
    // validasi rincian diskon
    if (dashboardCt.persenDiskonPesanBarang.value.text == "" ||
        dashboardCt.persenDiskonPesanBarang.value.text == "0") {
      dashboardCt.diskonHeader.value = 0.0;
      dashboardCt.diskonHeader.refresh();
    } else {
      dashboardCt.diskonHeader.value = Utility.validasiValueDouble(
          dashboardCt.persenDiskonPesanBarang.value.text);
      dashboardCt.diskonHeader.refresh();
    }
    // validasi rincian ppn
    if (dashboardCt.ppnPesan.value.text == "") {
      dashboardCt.ppnCabang.value = 0;
      dashboardCt.ppnCabang.refresh();
    } else {
      dashboardCt.ppnCabang.value =
          Utility.validasiValueDouble(dashboardCt.ppnPesan.value.text);
      dashboardCt.ppnCabang.refresh();
    }
    // validasi rincian service charge
    if (dashboardCt.serviceChargePesan.value.text == "") {
      dashboardCt.serviceChargerCabang.value = 0;
      dashboardCt.serviceChargerCabang.refresh();
    } else {
      dashboardCt.serviceChargerCabang.value = Utility.validasiValueDouble(
          dashboardCt.serviceChargePesan.value.text);
      dashboardCt.serviceChargerCabang.refresh();
    }
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.to(RincianPemesanan());
  }
}
