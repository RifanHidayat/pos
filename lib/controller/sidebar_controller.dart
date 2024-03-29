import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/screen/auth/login.dart';
import 'package:siscom_pos/screen/laporan/main_laporan.dart';
import 'package:siscom_pos/screen/pelanggan/list_pelanggan_view.dart';
import 'package:siscom_pos/screen/pengaturan/main_pengaturan.dart';
import 'package:siscom_pos/screen/pengaturan/setting_akun.dart';
import 'package:siscom_pos/screen/penjualan/dashboard_penjualan.dart';
import 'package:siscom_pos/screen/pos/dashboard_pos.dart';
import 'package:siscom_pos/screen/pusat_bantuan/main_pusatbantuan.dart';
import 'package:siscom_pos/screen/stockopname/stockopname.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SidebarController extends BaseController {
  var sidebarMenuSelected = 1.obs;

  var cabangKodeSelectedSide = "".obs;
  var cabangNameSelectedSide = "".obs;
  var gudangSelectedSide = "".obs;
  var ppnDefaultCabang = "".obs;
  var ipdevice = "".obs;
  var emailPengguna = "".obs;
  var passwordPengguna = "".obs;
  var dateTimeNow = DateTime.now().obs;
  final NetworkInfo _networkInfo = NetworkInfo();

  var listCabang = [].obs;
  var listCabangMaster = [].obs;

  @override
  void onInit() async {
    var dataUser = AppData.informasiLoginUser.split("-");
    emailPengguna.value = dataUser[0];
    emailPengguna.refresh();
    passwordPengguna.value = dataUser[1];
    passwordPengguna.refresh();
    getTimeNow();
    super.onInit();
  }

  void getTimeNow() {
    var dateNow = DateTime.now();
    dateTimeNow.value = dateNow;
    dateTimeNow.refresh();
  }

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
    listCabangMaster.value = data;
    listCabangMaster.refresh();
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

  Future<bool> pilihCabangSelected(kodeCabang) {
    bool statusCabang = false;
    for (var element in listCabang) {
      if (element["KODE"] == kodeCabang) {
        statusCabang = true;
        cabangKodeSelectedSide.value = element["KODE"];
        cabangNameSelectedSide.value = element["NAMA"];
        gudangSelectedSide.value = element["GUDANG"];
        ppnDefaultCabang.value = "${element["PPN"]}";
        cabangKodeSelectedSide.refresh();
        cabangNameSelectedSide.refresh();
        gudangSelectedSide.refresh();
        ppnDefaultCabang.refresh();
      }
    }
    return Future.value(statusCabang);
  }

  void changeRoutePage(value) async {
    Future<String> checkLocalIp = getLocalIpAddress();
    var ipLocal = await checkLocalIp;
    ipdevice.value = ipLocal;
    ipdevice.refresh();
    // print(AppData.informasiLoginUser);
    if (value == "pos") {
      if (sidebarMenuSelected.value != 1) {
        Get.back();
        Get.offAll(Dashboard());
        sidebarMenuSelected.value = 1;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "penjualan") {
      if (sidebarMenuSelected.value != 2) {
        Get.back();
        Get.offAll(DashboardPenjualan());
        sidebarMenuSelected.value = 2;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "stock-opname") {
      if (sidebarMenuSelected.value != 3) {
        Get.back();
        Get.offAll(StockOpname());
        sidebarMenuSelected.value = 3;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "pelanggan") {
      if (sidebarMenuSelected.value != 4) {
        Get.back();
        Get.offAll(ListPelangganView());
        sidebarMenuSelected.value = 4;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "laporan") {
      if (sidebarMenuSelected.value != 5) {
        Get.back();
        Get.offAll(LaporanMainView());
        sidebarMenuSelected.value = 5;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "pengaturan") {
      if (sidebarMenuSelected.value != 6) {
        Get.back();
        Get.offAll(MainPengaturan());
        sidebarMenuSelected.value = 6;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "pusat_bantuan") {
      if (sidebarMenuSelected.value != 7) {
        Get.back();
        Get.offAll(PusatBantuanMain());
        sidebarMenuSelected.value = 7;
        sidebarMenuSelected.refresh();
      }
    } else if (value == "personal_info") {
      Get.back();
      Get.to(SettingAkun(),
          duration: Duration(milliseconds: 300),
          transition: Transition.rightToLeftWithFade);
    }
  }

  static Future<String> getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return "";
        }
      }
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
              sidebarMenuSelected.value = 1;
              sidebarMenuSelected.refresh();
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
