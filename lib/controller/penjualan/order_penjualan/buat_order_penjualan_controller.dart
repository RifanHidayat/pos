import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class BuatOrderPenjualanController extends BaseController {
  var dashboardSoCt = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());

  Future<bool> getAkhirNomorSo() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses simpan so");
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
    };
    var connect = Api.connectionApi("post", body, "get_last_so");
    bool prosesBuatFaktur = false;

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var dt = DateTime.now();

    if (valueBody['status'] == true) {
      var tanggalLastFaktur = "";
      var nomorSoFinal = "";
      var nomorCbSoFinal = "";
      if (data.isEmpty) {
        tanggalLastFaktur = "";
        nomorSoFinal = "SO${DateFormat('yyyyMM').format(dt)}0001";
        nomorCbSoFinal = "SO${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        tanggalLastFaktur = data[0]['TANGGAL'];
        var lastNomorCbSo = data[0]['NOMORCB'];
        var lastNomorSo = data[0]['NOMOR'];

        var filterNmrSo1 = lastNomorSo.substring(2);
        var filterNmrSo2 = int.parse(filterNmrSo1) + 1;
        nomorSoFinal = "SO$filterNmrSo2";

        var filterNmrCbSo1 = lastNomorCbSo.substring(2);
        var filterNmrCbSo2 = int.parse(filterNmrCbSo1) + 1;
        nomorCbSoFinal = "SO$filterNmrCbSo2";
      }

      print('tanggal $tanggalLastFaktur');
      print('nomor so $nomorSoFinal');
      print('nomor cb $nomorCbSoFinal');

      Future<bool> prosesNomor = insertSoBaru(nomorSoFinal, nomorCbSoFinal);
      prosesBuatFaktur = await prosesNomor;
    }

    return Future.value(prosesBuatFaktur);
  }

  Future<bool> insertSoBaru(nomorSoFinal, nomorCbSoFinal) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    var ppnSo = dashboardSoCt.checkIncludePPN.value == false ? "N" : "Y";

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SOHD',
      'sohd_cabang': "01",
      'sohd_nomor': "$nomorSoFinal",
      'sohd_nomorcb': "$nomorCbSoFinal",
      'sohd_noref': dashboardSoCt.refrensiBuatOrderPenjualan.value.text,
      'sohd_tanggal': tanggalNow,
      'sohd_tglinv': tanggalNow,
      'sohd_term': dashboardSoCt.jatuhTempoBuatOrderPenjualan.value.text,
      'sohd_tgltjp': tanggalNow,
      'sohd_custom': dashboardSoCt.selectedIdPelanggan.value,
      'sohd_wilayah': dashboardSoCt.wilayahCustomerSelected.value,
      'sohd_salesm': dashboardSoCt.selectedIdSales.value,
      'sohd_uang': "RP",
      'sohd_kurs': "1",
      'sohd_ket1': dashboardSoCt.keteranganSO1.value.text,
      'sohd_ket2': dashboardSoCt.keteranganSO2.value.text,
      'sohd_ket3': dashboardSoCt.keteranganSO3.value.text,
      'sohd_ket4': dashboardSoCt.keteranganSO4.value.text,
      'sohd_id1': dataInformasiSYSUSER[0],
      'sohd_doe': tanggalDanJam,
      'sohd_toe': jamTransaksi,
      'sohd_loe': tanggalDanJam,
      'sohd_deo': dataInformasiSYSUSER[0],
      'sohd_ip': sidebarCt.ipdevice.value,
      'sohd_cb': sidebarCt.cabangKodeSelectedSide.value,
      'sohd_ppn': ppnSo
    };
    var connect = Api.connectionApi("post", body, "insert_sohd");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);

    if (valueBody['status'] == true) {
      Get.back();
      UtilsAlert.showToast("SO Berhasil di buat");
      dashboardSoCt.nomorSoSelected.value = nomorSoFinal;
      dashboardSoCt.nomorSoSelected.refresh();
      dashboardSoCt.getDataSOHD();
      Get.to(ItemOrderPenjualan(),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeftWithFade);
    } else {
      getAkhirNomorSo();
    }

    return Future.value(true);
  }
}
