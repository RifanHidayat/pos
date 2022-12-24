import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class ButtonSheetController extends GetxController {
  void validasiButtonSheet(
      String pesan1, Widget content, String type, Function() onTap) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Button1(
                          textBtn: "Simpan",
                          colorBtn: Utility.primaryDefault,
                          onTap: () {
                            if (onTap != null) onTap();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: Utility.borderStyle1,
                                border:
                                    Border.all(color: Utility.primaryDefault)),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                child: Text(
                                  "Urungkan",
                                  style:
                                      TextStyle(color: Utility.primaryDefault),
                                ),
                              ),
                            )),
                      ),
                    )
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
