import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class SimpanSODTController extends GetxController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var itemOrderPenjualanCt = Get.put(ItemOrderPenjualanController());
  var sidebarCt = Get.put(SidebarController());

  Future<List> buatSodt(produkSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Simpan data...");

    // informasi SOHD
    var dataSohd = dashboardPenjualanCt.dataSohd[0];

    // INFORMASI NOURUT DAN NOKEY
    String nomorUrut = "";
    String nomorKey = "";
    if (itemOrderPenjualanCt.sodtSelected.isNotEmpty) {
      var getLastList = itemOrderPenjualanCt.sodtSelected.last;

      int getNoUrut = int.parse("${getLastList['NOURUT']}");
      int hitungNoUrut = getNoUrut + 1;

      int getNoKey = int.parse("${getLastList['NOKEY']}");
      int hitungNoKey = getNoKey + 1;

      nomorUrut = "$hitungNoUrut".length == 1
          ? "0000$hitungNoUrut"
          : "$hitungNoUrut".length == 2
              ? "000$hitungNoUrut"
              : "$hitungNoUrut".length == 3
                  ? "00$hitungNoUrut"
                  : "$hitungNoUrut".length == 4
                      ? "0$hitungNoUrut"
                      : "$hitungNoUrut";
      nomorKey = "$hitungNoKey".length == 1
          ? "0000$hitungNoKey"
          : "$hitungNoKey".length == 2
              ? "000$hitungNoKey"
              : "$hitungNoKey".length == 3
                  ? "00$hitungNoKey"
                  : "$hitungNoKey".length == 4
                      ? "0$hitungNoKey"
                      : "$hitungNoKey";
    } else {
      nomorUrut = "00001";
      nomorKey = "00001";
    }

    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SOHD',
      'sodt_pk': dataSohd['PK'],
      'sodt_cabang': "01",
      'sodt_nomor': dataSohd['NOMOR'],
      'sodt_nomorcb': dataSohd['NOMORCB'],
      'sodt_nourut': nomorUrut,
      'sodt_nokey': nomorKey,
      'sodt_cbxx': "01",
      'sodt_noxx': dataSohd['NOMOR'],
      'sodt_nosub': nomorUrut,
      'sodt_noref': "",
      'sodt_ref': "",
      'sodt_tanggal': tanggalNow,
      'sodt_tgl': tanggalNow,
      'sodt_custom': dataSohd['CUSTOM'],
      'sodt_wilayah': dataSohd['WILAYAH'],
      'sodt_salesm': dataSohd['SALESM'],
      'sodt_gudang': sidebarCt.gudangSelectedSide.value,
      'sodt_group': produkSelected[0]['GROUP'],
      'sodt_barang': produkSelected[0]['BARANG'],
      'sodt_qty': itemOrderPenjualanCt.jumlahPesan.value.text,
      'sodt_sat': produkSelected[0]['SAT'],
      'sodt_uang': "RP",
      'sodt_kurs': "1",
      'sodt_harga': itemOrderPenjualanCt.hargaJualPesanBarang.value.text,
      'sodt_disc1': itemOrderPenjualanCt.persenDiskonPesanBarang.value.text,
      'sodt_discd': itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text,
      'sodt_disch': "",
      'sodt_discn': "",
      'sodt_biaya': "",
      'sodt_taxn': "",
      'sodt_lain': "",
      'sodt_doe': tanggalDanJam,
      'sodt_toe': jamTransaksi,
      'sodt_loe': tanggalDanJam,
      'sodt_deo': dataInformasiSYSUSER[0],
      'sodt_cb': sidebarCt.cabangKodeSelectedSide.value,
      'sodt_htg': itemOrderPenjualanCt.pakBarangSelected.value,
      'sodt_ptg': "1",
      'sodt_pak': itemOrderPenjualanCt.htgBarangSelected.value,
      'sodt_hgpak': itemOrderPenjualanCt.hargaJualPesanBarang.value.text,
    };
    var connect = Api.connectionApi("post", body, "insert_sodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List hasil = [];
    if (valueBody["status"] == true) {
      hasil = [true, valueBody["data"]];
    }
    Get.back();
    return Future.value(hasil);
  }
}
