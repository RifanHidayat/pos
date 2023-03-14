import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/model/detail_barang.dart';
import 'package:siscom_pos/model/stok_opname/list_stok_opname.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/request.dart';
import 'package:siscom_pos/utils/toast.dart';

class PusatBantuanController extends GetxController {
  var screenLoad = false.obs;

  var listDataBantuan = [].obs;

  List dummyData = [
    {
      "id": 1,
      "title": "Lorem ipsum dolor sit amet",
      "view": false,
      "deskripsi":
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
    },
    {
      "id": 2,
      "title": "Lorem ipsum dolor sit amet",
      "view": false,
      "deskripsi":
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
    },
    {
      "id": 3,
      "title": "Lorem ipsum dolor sit amet",
      "view": false,
      "deskripsi":
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
    },
    {
      "id": 4,
      "title": "Lorem ipsum dolor sit amet",
      "view": false,
      "deskripsi":
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
    },
  ];

  var pencarian = TextEditingController().obs;

  void startLoad() {
    prosesGetBantuan();
  }

  void prosesGetBantuan() {
    for (var element in dummyData) {
      listDataBantuan.add(element);
    }
    listDataBantuan.refresh();
    screenLoad.value = true;
    screenLoad.refresh();
  }

  void openCard(id) {
    for (var element in listDataBantuan) {
      if (element["id"] == id) {
        element["view"] = !element["view"];
      } else {
        element["view"] = false;
      }
    }
    listDataBantuan.refresh();
  }
}
