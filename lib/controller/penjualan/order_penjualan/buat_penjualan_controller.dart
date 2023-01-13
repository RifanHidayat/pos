import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/detail_nota_pengiriman_barang.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class BuatPenjualanController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());

  void clearAll() {}

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

    var ppnSo = dashboardPenjualanCt.checkIncludePPN.value == false ? "N" : "Y";

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SOHD',
      'sohd_cabang': "01",
      'sohd_nomor': "$nomorSoFinal",
      'sohd_nomorcb': "$nomorCbSoFinal",
      'sohd_noref': dashboardPenjualanCt.refrensiBuatOrderPenjualan.value.text,
      'sohd_tanggal': tanggalNow,
      'sohd_tglinv': tanggalNow,
      'sohd_term': dashboardPenjualanCt.jatuhTempoBuatOrderPenjualan.value.text,
      'sohd_tgltjp': tanggalNow,
      'sohd_custom': dashboardPenjualanCt.selectedIdPelanggan.value,
      'sohd_wilayah': dashboardPenjualanCt.wilayahCustomerSelected.value,
      'sohd_salesm': dashboardPenjualanCt.selectedIdSales.value,
      'sohd_uang': "RP",
      'sohd_kurs': "1",
      'sohd_ket1': dashboardPenjualanCt.keteranganSO1.value.text,
      'sohd_ket2': dashboardPenjualanCt.keteranganSO2.value.text,
      'sohd_ket3': dashboardPenjualanCt.keteranganSO3.value.text,
      'sohd_ket4': dashboardPenjualanCt.keteranganSO4.value.text,
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
      dashboardPenjualanCt.nomorSoSelected.value = nomorSoFinal;
      dashboardPenjualanCt.nomorSoSelected.refresh();
      Future<bool> prosesGetAllSOHD = dashboardPenjualanCt.getDataAllSOHD();
      bool hasilGetAll = await prosesGetAllSOHD;
      if (hasilGetAll) {
        Get.to(ItemOrderPenjualan(dataForm: false),
            duration: Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade);
      }
    } else {
      getAkhirNomorSo();
    }

    return Future.value(true);
  }

  Future<bool> getAkhirNomorDo() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses simpan do");
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DOHD',
    };
    var connect = Api.connectionApi("post", body, "get_last_do");
    bool prosesBuatNota = false;

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var dt = DateTime.now();

    if (valueBody['status'] == true) {
      var tanggalLastFaktur = "";
      var nomorDoFinal = "";
      var nomorCbDoFinal = "";
      if (data.isEmpty) {
        tanggalLastFaktur = "";
        nomorDoFinal = "DO${DateFormat('yyyyMM').format(dt)}0001";
        nomorCbDoFinal = "DO${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        tanggalLastFaktur = data[0]['TANGGAL'];
        var lastNomorCbDo = data[0]['NOMORCB'];
        var lastNomorDo = data[0]['NOMOR'];

        var filterNmr1 = lastNomorDo.substring(2);
        var filterNmr2 = int.parse(filterNmr1) + 1;
        nomorDoFinal = "DO$filterNmr2";

        var filterNmrCb1 = lastNomorCbDo.substring(2);
        var filterNmrCb2 = int.parse(filterNmrCb1) + 1;
        nomorCbDoFinal = "DO$filterNmrCb2";
      }

      print('tanggal $tanggalLastFaktur');
      print('nomor do $nomorDoFinal');
      print('nomor cb $nomorCbDoFinal');

      Future<bool> prosesNomorNota = insertDoBaru(nomorDoFinal, nomorCbDoFinal);
      prosesBuatNota = await prosesNomorNota;
    }

    return Future.value(prosesBuatNota);
  }

  Future<bool> insertDoBaru(nomorDoFinal, nomorCbDoFinal) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    var ppnDo = dashboardPenjualanCt.checkIncludePPN.value == false ? "N" : "Y";

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'DOHD',
      'dohd_cabang': "01",
      'dohd_nomor': "$nomorDoFinal",
      'dohd_noref': dashboardPenjualanCt.refrensiBuatOrderPenjualan.value.text,
      'dohd_tanggal': tanggalNow,
      'dohd_tglinv': tanggalNow,
      'dohd_term': dashboardPenjualanCt.jatuhTempoBuatOrderPenjualan.value.text,
      'dohd_tgltjp': tanggalNow,
      'dohd_custom': dashboardPenjualanCt.selectedIdPelanggan.value,
      'dohd_wilayah': dashboardPenjualanCt.wilayahCustomerSelected.value,
      'dohd_salesm': dashboardPenjualanCt.selectedIdSales.value,
      'dohd_uang': "RP",
      'dohd_kurs': "1",
      'dohd_ket1': dashboardPenjualanCt.keteranganSO1.value.text,
      'dohd_ket2': dashboardPenjualanCt.keteranganSO2.value.text,
      'dohd_ket3': dashboardPenjualanCt.keteranganSO3.value.text,
      'dohd_ket4': dashboardPenjualanCt.keteranganSO4.value.text,
      'dohd_doe': tanggalDanJam,
      'dohd_toe': jamTransaksi,
      'dohd_loe': tanggalDanJam,
      'dohd_deo': dataInformasiSYSUSER[0],
      'dohd_ip': sidebarCt.ipdevice.value,
      'dohd_cb': sidebarCt.cabangKodeSelectedSide.value,
      'dohd_ppn': ppnDo,
      'dohd_nomorcb': "$nomorCbDoFinal"
    };
    var connect = Api.connectionApi("post", body, "insert_dohd");

    var getValueNota = await connect;
    var valueBodyNota = jsonDecode(getValueNota.body);

    if (valueBodyNota['status'] == true) {
      Get.back();
      UtilsAlert.showToast("DO Berhasil di buat");
      dashboardPenjualanCt.nomorDoSelected.value = nomorDoFinal;
      dashboardPenjualanCt.nomorDoSelected.refresh();
      Future<bool> prosesGetAllDOHD = dashboardPenjualanCt.getDataAllDOHD();
      bool hasilGetAll = await prosesGetAllDOHD;
      if (hasilGetAll) {
        Get.to(DetailNotaPengirimanBarang(dataForm: true),
            duration: Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade);
      }
    } else {
      getAkhirNomorDo();
    }

    return Future.value(true);
  }
}
