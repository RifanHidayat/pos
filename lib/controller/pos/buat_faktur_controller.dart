import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class BuatFakturController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var arsipFakturCt = Get.put(ArsipFakturController());

  Future<bool> getAkhirNomorFaktur() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'JLHD',
    };
    var connect = Api.connectionApi("post", body, "get_last_faktur");
    bool prosesBuatFaktur = false;

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];

    if (valueBody['status'] == true) {
      var tanggalLastFaktur = data[0]['TANGGAL'];
      var nomorAntriLastFaktur = data[0]['NOMORANTRI'];
      var getfaktur = data[0]['NOMOR'];
      var filter = getfaktur.substring(2);
      var filter2 = int.parse(filter) + 1;
      var lastFaktur = "SI$filter2";
      var dt = DateTime.now();

      var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
      var inputDate = Utility.convertDate4(tanggalLastFaktur);
      if (tanggalNow == inputDate) {
        // print(nomorAntriLastFaktur);
        if (nomorAntriLastFaktur == null || nomorAntriLastFaktur == "") {
          print('nomor antri tidak valid');
          dashboardCt.nomorOrder.value =
              "${DateFormat('yyyyMMdd').format(dt)}001";
        } else {
          print('nomor antri valid');
          var ft1 =
              nomorAntriLastFaktur.substring(nomorAntriLastFaktur.length - 3);
          var ft2 = int.parse(ft1) + 1;
          if (ft2 <= 9) {
            dashboardCt.nomorOrder.value =
                "${DateFormat('yyyyMMdd').format(dt)}00$ft2";
          } else if (ft2 <= 99) {
            dashboardCt.nomorOrder.value =
                "${DateFormat('yyyyMMdd').format(dt)}0$ft2";
          } else if (ft2 < 999) {
            dashboardCt.nomorOrder.value =
                "${DateFormat('yyyyMMdd').format(dt)}$ft2";
          }
        }
      } else {
        dashboardCt.nomorOrder.value =
            "${DateFormat('yyyyMMdd').format(dt)}001";
      }
      dashboardCt.nomorOrder.refresh();
      // print(getfaktur);
      // print(filter2);
      // print(lastFaktur);
      Future<bool> prosesNomor = getAkhirNomorCBJLHD(lastFaktur);
      prosesBuatFaktur = await prosesNomor;
    }

    return Future.value(prosesBuatFaktur);
  }

  Future<bool> getAkhirNomorCBJLHD(lastFaktur) async {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'kode_cabang': '${dashboardCt.cabangKodeSelected.value}',
    };
    var connect = Api.connectionApi("post", body, "get_last_nomorcb_jlhd");
    bool proses2 = false;

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];

    if (valueBody['status'] == true) {
      var getNomorCb = data[0]['NOMORCB'];
      var filter = getNomorCb.substring(2);
      var filter2 = int.parse(filter) + 1;
      var lastNomorCB = "SI$filter2";
      Future<bool> prosesInsert = insertFakturBaru(lastFaktur, lastNomorCB);
      proses2 = await prosesInsert;
    }

    return Future.value(proses2);
  }

  Future<bool> insertFakturBaru(lastFaktur, lastNomorCB) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'jlhd_cabang': "01",
      'jlhd_nomor': "$lastFaktur",
      'jlhd_reff': "${dashboardCt.reff.value.text}",
      'jlhd_tanggal': "$tanggalNow",
      'jlhd_tglinv': "$tanggalNow",
      'jlhd_term': "0",
      'jlhd_tgltjp': "$tanggalNow",
      'jlhd_custom': "${dashboardCt.customSelected.value}",
      'jlhd_wilayah': "${dashboardCt.wilayahCustomerSelected.value}",
      'jlhd_salesm': "${dashboardCt.kodePelayanSelected.value}",
      'jlhd_uang': "RP",
      'jlhd_kurs': "1",
      'jlhd_ket1': "${dashboardCt.keteranganInsertFaktur.value.text}",
      'jlhd_cb': "${dashboardCt.cabangKodeSelected.value}",
      'jlhd_doe': tanggalDanJam,
      'jlhd_toe': jamTransaksi,
      'jlhd_loe': tanggalDanJam,
      'jlhd_deo': dataInformasiSYSUSER[0],
      'jlhd_nomorcb': "$lastNomorCB",
      'jlhd_nomorantri': "${dashboardCt.nomorOrder.value}",
      'jlhd_taxp': "${dashboardCt.ppnCabang.value}"
    };
    var connect = Api.connectionApi("post", body, "buat_faktur");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);

    if (valueBody['status'] == true) {
      dashboardCt.nomorFaktur.value = lastFaktur;
      dashboardCt.primaryKeyFaktur.value = "${valueBody['primaryKey']}";
      dashboardCt.nomorCbLastSelected.value = lastNomorCB;
      dashboardCt.reff.value.text = "";
      dashboardCt.keteranganInsertFaktur.value.text = "";
      if (AppData.noFaktur != "") {
        AppData.noFaktur =
            "${AppData.noFaktur}|${dashboardCt.nomorFaktur.value}-${dashboardCt.primaryKeyFaktur.value}-$lastNomorCB-${dashboardCt.nomorOrder.value}";
      } else {
        AppData.noFaktur =
            "${dashboardCt.nomorFaktur.value}-${dashboardCt.primaryKeyFaktur.value}-$lastNomorCB-${dashboardCt.nomorOrder.value}";
      }
      dashboardCt.nomorFaktur.refresh();
      dashboardCt.primaryKeyFaktur.refresh();
      print("nomor faktur ${dashboardCt.nomorFaktur.value}");
      print("key faktur ${dashboardCt.primaryKeyFaktur.value}");
      dashboardCt.checkingJlhdArsip();
      UtilsAlert.showToast("Berhasil buat faktur");
      Get.back();
      Get.back();
    } else {
      getAkhirNomorFaktur();
    }

    return Future.value(true);
  }
}
