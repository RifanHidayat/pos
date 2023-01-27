import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

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

    double hargaJualBarangFilter = 0.0;
    double nominalDiskonFilter = 0.0;

    // check data cabang selected
    Future<List> getCabang = GetDataController().getSpesifikData(
        "CABANG",
        "KODE",
        sidebarCt.cabangKodeSelectedSide.value,
        "get_spesifik_data_master");
    List hasilCabang = await getCabang;
    int ppnCabangSelected = 0;
    if (hasilCabang.isNotEmpty) {
      ppnCabangSelected = hasilCabang[0]['PPN'];
    }

    if (itemOrderPenjualanCt.hargaJualPesanBarang.value.text != "") {
      var tampungHargaJual1 = Utility.convertStringRpToDouble(
          itemOrderPenjualanCt.hargaJualPesanBarang.value.text);

      if (dashboardPenjualanCt.includePPN.value == "Y") {
        if (ppnCabangSelected > 0) {
          double hitung1 =
              tampungHargaJual1 * (100 / (100 + ppnCabangSelected));
          hargaJualBarangFilter = hitung1;
        } else {
          hargaJualBarangFilter = tampungHargaJual1;
        }
      } else {
        if (dashboardPenjualanCt.checkIncludePPN.value == true) {
          if (ppnCabangSelected > 0) {
            double hitung1 =
                tampungHargaJual1 * (100 / (100 + ppnCabangSelected));
            hargaJualBarangFilter = hitung1;
          } else {
            hargaJualBarangFilter = tampungHargaJual1;
          }
        } else {
          hargaJualBarangFilter = tampungHargaJual1;
        }
      }
    }

    if (itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text != "") {
      nominalDiskonFilter = Utility.convertStringRpToDouble(
          itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text);
    }

    var disc1Final = 0.0;

    if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "") {
      var disc1Proses1 = itemOrderPenjualanCt.persenDiskonPesanBarang.value.text
          .replaceAll(",", ".");
      var disc1Proses2 = disc1Proses1.replaceAll(".", ".");
      disc1Final = double.parse(disc1Proses2);
    }

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SODT',
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
      'sodt_kode': produkSelected[0]['KODE'],
      'sodt_qty': itemOrderPenjualanCt.jumlahPesan.value.text,
      'sodt_sat': produkSelected[0]['SAT'],
      'sodt_uang': "RP",
      'sodt_kurs': "1",
      'sodt_harga': hargaJualBarangFilter,
      'sodt_disc1': disc1Final,
      'sodt_discd': nominalDiskonFilter,
      'sodt_doe': tanggalDanJam,
      'sodt_toe': jamTransaksi,
      'sodt_loe': tanggalDanJam,
      'sodt_deo': dataInformasiSYSUSER[0],
      'sodt_cb': sidebarCt.cabangKodeSelectedSide.value,
      'sodt_htg': itemOrderPenjualanCt.htgBarangSelected.value,
      'sodt_ptg': "1",
      'sodt_pak': itemOrderPenjualanCt.pakBarangSelected.value,
      'sodt_hgpak': hargaJualBarangFilter,
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

  Future<List> editSODT(produkSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Edit data...");
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    double hargaJualBarangFilter = 0.0;
    double nominalDiskonFilter = 0.0;

    if (itemOrderPenjualanCt.hargaJualPesanBarang.value.text != "") {
      hargaJualBarangFilter = Utility.convertStringRpToDouble(
          itemOrderPenjualanCt.hargaJualPesanBarang.value.text);
    }
    if (itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text != "") {
      nominalDiskonFilter = Utility.convertStringRpToDouble(
          itemOrderPenjualanCt.nominalDiskonPesanBarang.value.text);
    }

    var disc1Final = 0.0;

    if (itemOrderPenjualanCt.persenDiskonPesanBarang.value.text != "") {
      var disc1Proses1 = itemOrderPenjualanCt.persenDiskonPesanBarang.value.text
          .replaceAll(",", ".");
      var disc1Proses2 = disc1Proses1.replaceAll(".", ".");
      disc1Final = double.parse(disc1Proses2);
    }

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SODT',
      'nomor_sohd': dashboardPenjualanCt.dataSohd[0]['NOMOR'],
      'nomor_urut': produkSelected[0]['NOURUT'],
      'sodt_edit_tanggal': tanggalNow,
      'sodt_edit_tgl': tanggalNow,
      'sodt_edit_qty': itemOrderPenjualanCt.jumlahPesan.value.text,
      'sodt_edit_sat': produkSelected[0]['SAT'],
      'sodt_edit_harga': hargaJualBarangFilter.toStringAsFixed(2),
      'sodt_edit_disc1': disc1Final.toStringAsFixed(2),
      'edit_discd': nominalDiskonFilter.toStringAsFixed(2),
      'sodt_edit_doe': tanggalDanJam,
      'sodt_edit_toe': jamTransaksi,
      'sodt_edit_loe': tanggalDanJam,
      'sodt_edit_deo': dataInformasiSYSUSER[0],
      'sodt_edit_htg': itemOrderPenjualanCt.htgBarangSelected.value,
      'sodt_edit_pak': itemOrderPenjualanCt.pakBarangSelected.value,
    };
    var connect = Api.connectionApi("post", body, "update_item_sodt");
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
