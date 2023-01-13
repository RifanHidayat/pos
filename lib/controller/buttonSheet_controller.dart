import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class ButtonSheetController extends GetxController {
  void validasiButtonSheet(String pesan1, Widget content, String type,
      String acc, Function() onTap) {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$pesan1",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: InkWell(
                          onTap: () => Navigator.pop(Get.context!),
                          child: Icon(
                            Iconsax.close_circle,
                            color: Colors.red,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: Utility.small,
                ),
                Divider(),
                SizedBox(
                  height: Utility.medium,
                ),
                content,
                SizedBox(
                  height: Utility.medium,
                ),
                type == "validasi_lanjutkan_orderpenjualan" ||
                        type == "cetak_faktur_penjualan" ||
                        type == "show_keterangan"
                    ? SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                  margin: EdgeInsets.only(right: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: Utility.borderStyle1,
                                      border: Border.all(
                                          color: Utility.primaryDefault)),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 12, bottom: 12),
                                      child: Text(
                                        "Urungkan",
                                        style: TextStyle(
                                            color: Utility.primaryDefault),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Button1(
                                textBtn: acc,
                                colorBtn: Utility.primaryDefault,
                                onTap: () {
                                  if (onTap != null) onTap();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          );
        });
      },
    );
  }
}
