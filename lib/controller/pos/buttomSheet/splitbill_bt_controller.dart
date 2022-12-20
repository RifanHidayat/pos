import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';
import 'package:siscom_pos/screen/pos/split_bill.dart';
import 'package:siscom_pos/screen/pos/split_jumlah_bayar.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class SplitBillBtSheetController extends BaseController {
  var splitJumlahBayarCt = Get.put(SplitJumlahBayarController());

  void pilihMetodeSplit() {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
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
                      height: Utility.large,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 90,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pilih Metode Split",
                                    style: TextStyle(
                                        fontSize: Utility.large,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Kamu bisa melakukan pembayaran secara terpisah",
                                    style: TextStyle(
                                        fontSize: Utility.small,
                                        color: Utility.nonAktif),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 10,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Center(child: Icon(Iconsax.close_circle))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        splitJumlahBayarCt.perhitunganSisaTotal();
                        splitJumlahBayarCt.listPembayaranSplit.value.clear();
                        Get.to(SpliJumlahBayar(),
                            duration: Duration(milliseconds: 500),
                            transition: Transition.downToUp);
                      },
                      child: CardCustom(
                        radiusBorder: Utility.borderStyle1,
                        colorBg: Colors.white,
                        widgetCardCustom: Padding(
                          padding: EdgeInsets.all(8),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: Icon(
                                      Iconsax.money,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Split Jumlah",
                                            style: TextStyle(
                                                fontSize: Utility.medium,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Buat metode pembayaran secara terpisah",
                                            style: TextStyle(
                                                fontSize: Utility.small,
                                                color: Utility.nonAktif),
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: Icon(
                                      Iconsax.arrow_right,
                                      color: Utility.greyDark,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(SplitBill(),
                            duration: Duration(milliseconds: 500),
                            transition: Transition.downToUp);
                      },
                      child: CardCustom(
                        radiusBorder: Utility.borderStyle1,
                        colorBg: Colors.white,
                        widgetCardCustom: Padding(
                          padding: EdgeInsets.all(8),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: Icon(
                                      Iconsax.bill,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Split Bill",
                                            style: TextStyle(
                                                fontSize: Utility.medium,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Buat tagihan secara terpisah",
                                            style: TextStyle(
                                                fontSize: Utility.small,
                                                color: Utility.nonAktif),
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: Icon(
                                      Iconsax.arrow_right,
                                      color: Utility.greyDark,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    CardCustom(
                      radiusBorder: Utility.borderStyle1,
                      colorBg: Utility.errorLight,
                      widgetCardCustom: Padding(
                        padding: EdgeInsets.all(8),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Center(
                                  child: Icon(
                                    Iconsax.info_circle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Dengan memilih split pembayaran, Kamu tidak dapat kembali sampai proses transaksi selesai.",
                                      style: TextStyle(
                                          fontSize: Utility.small,
                                          color: Utility.nonAktif),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                  ]));
        });
  }
}
