import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/screen/auth/login.dart';
import 'package:siscom_pos/screen/penjualan/dashboard_penjualan.dart';
import 'package:siscom_pos/screen/pos/dashboard_pos.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class SidebarController extends BaseController {
  var sidebarMenuSelected = 1.obs;

  var cabangKodeSelectedSide = "".obs;
  var cabangNameSelectedSide = "".obs;
  var gudangSelectedSide = "".obs;

  var listCabang = [].obs;

  void getCabang() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'CABANG',
    };
    var connect = Api.connectionApi("post", body, "cabang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var sysUser = AppData.sysuserInformasi.split("-");
    var hakAksesCabang = sysUser[3].split(" ");
    List filter = [];
    for (var element in data) {
      for (var element1 in hakAksesCabang) {
        if (element1 == element["KODE"]) {
          filter.add(element);
        }
      }
    }
    var getFirst = filter.first;
    cabangKodeSelectedSide.value = getFirst["KODE"];
    cabangNameSelectedSide.value = getFirst["NAMA"];
    gudangSelectedSide.value = getFirst["GUDANG"];

    listCabang.value = filter;
    listCabang.refresh();
  }

  void changeRoutePage(value) {
    if (value == "pos") {
      Get.back();
      Get.offAll(Dashboard());
      sidebarMenuSelected.value = 1;
      sidebarMenuSelected.refresh();
    } else if (value == "penjualan") {
      Get.back();
      Get.offAll(DashboardPenjualan());
      sidebarMenuSelected.value = 2;
      sidebarMenuSelected.refresh();
    }
  }

  void logout() {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: ModalPopup(
            // our custom dialog
            title: "Peringatan",
            content: "Yakin Keluar Akun",
            positiveBtnText: "Keluar",
            negativeBtnText: "Kembali",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: () {
              AppData.databaseSelected = "";
              AppData.periodeSelected = "";
              AppData.cabangSelected = "";
              Get.offAll(Login());
            },
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }
}
