import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/components/button/button_costum.dart';
import 'package:siscom_pos/utils/utility.dart';

import '../../../../screen/pos/scan_barang.dart';

class Body {
  static form() {
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
                      controller: TextEditingController(),
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
                    onPressed: () {},
                    title: 'OK'),
              ],
            ),
          ),
          ButtonCostum.dashbutton(
              icon: Iconsax.scan,
              onPressed: () {
                Get.back();
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
