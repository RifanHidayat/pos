import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Header {
  static Widget header(String judul) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 90,
            child: Text(
              judul,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
              flex: 10,
              child: InkWell(
                  onTap: () => Navigator.pop(Get.context!),
                  child: Icon(Iconsax.close_circle)))
        ],
      ),
    );
  }
}
