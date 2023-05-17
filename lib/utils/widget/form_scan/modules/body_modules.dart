import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/components/button/button_costum.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

import '../../../../controller/global_controller.dart';
import '../../../../controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import '../../../../controller/pos/dashboard_controller.dart';
import '../../../../controller/pos/scan_barang_controller.dart';
import '../../../../screen/pos/scan_barang.dart';

class Body extends GetxController {
  var controller = TextEditingController(text: '');
  var scanBarangCt = Get.put(ScanBarangController());
  final dashboradcontroller = Get.put(DashbardController());
  var globalCt = Get.put(GlobalController());
  var buttomSheetProduk = Get.put(BottomSheetPos());
  form() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Utility.grey300,
                          width: 1,
                        )),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: controller,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Input Barcode"),
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ),
                ButtonCostum.buttontransparanst(
                    width: 100,
                    margin: EdgeInsets.only(left: 20),
                    onPressed: () {
                      scanBarangCt.getBarcode(
                          'get_qrcode_manualy', controller.text,
                          key: 'get_qrcode_manualy');
                    },
                    title: 'OK'),
              ],
            ),
          ),
          ButtonCostum.dashbutton(
              icon: Iconsax.scan,
              onPressed: () {
                Get.back();
                scanBarangCt.scannerValue.value = false;
                scanBarangCt.scannerValue.refresh();
                Get.to(ScanBarang());
              },
              title: 'Scan Barcode'),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
