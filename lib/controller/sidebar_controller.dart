import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/screen/penjualan/list_penjualan.dart';
import 'package:siscom_pos/screen/pos/dashboard_pos.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';

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
      Get.offAll(ListPenjualan());
      sidebarMenuSelected.value = 2;
      sidebarMenuSelected.refresh();
    }
  }
}
