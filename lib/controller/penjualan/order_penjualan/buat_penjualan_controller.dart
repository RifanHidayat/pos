import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/detail_nota_pengiriman_barang.dart';
import 'package:siscom_pos/screen/penjualan/faktur_penjualan_si.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class BuatPenjualanController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());
  var itemOrderPenjualanCt = Get.put(ItemOrderPenjualanController());

  void clearAll() {}

  Future<bool> getAkhirNomorSo() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses simpan...");
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

      if (data.isEmpty) {
        tanggalLastFaktur = "";
        nomorSoFinal = "SO${DateFormat('yyyyMM').format(dt)}0001";
        // nomorCbSoFinal = "SO${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        tanggalLastFaktur = data[0]['TANGGAL'];
        // var lastNomorCbSo = data[0]['NOMORCB'];
        var lastNomorSo = data[0]['NOMOR'];

        var filterNmrSo1 = lastNomorSo.substring(2);
        var filterNmrSo2 = int.parse(filterNmrSo1) + 1;
        nomorSoFinal = "SO$filterNmrSo2";

        // var filterNmrCbSo1 = lastNomorCbSo.substring(2);
        // var filterNmrCbSo2 = int.parse(filterNmrCbSo1) + 1;
        // nomorCbSoFinal = "SO$filterNmrCbSo2";
      }

      print('tanggal $tanggalLastFaktur');
      print('nomor so $nomorSoFinal');
      // print('nomor cb $nomorCbSoFinal');

      Future<bool> prosesNomor = checkNomorCBSO(nomorSoFinal);
      prosesBuatFaktur = await prosesNomor;
    }

    return Future.value(prosesBuatFaktur);
  }

  Future<bool> checkNomorCBSO(nomorSoFinal) async {
    bool prosesBuatFaktur = false;

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SOHD',
      'kode_cabang': sidebarCt.cabangKodeSelectedSide.value,
    };
    var connect = Api.connectionApi("post", body, "get_last_nomorcb");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var dt = DateTime.now();

    if (valueBody['status'] == true) {
      var nomorSoCBFinal = "";

      if (data.isEmpty) {
        nomorSoCBFinal = "SO${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        var lastNomorCbSo = data[0]['NOMORCB'];
        var filterNmrCbSo1 = lastNomorCbSo.substring(2);
        var filterNmrCbSo2 = int.parse(filterNmrCbSo1) + 1;
        nomorSoCBFinal = "SO$filterNmrCbSo2";
      }

      Future<bool> prosesNomor = insertSoBaru(nomorSoFinal, nomorSoCBFinal);
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
    var termValue =
        dashboardPenjualanCt.jatuhTempoBuatOrderPenjualan.value.text == ""
            ? "0"
            : dashboardPenjualanCt.jatuhTempoBuatOrderPenjualan.value.text;

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
      'sohd_term': termValue,
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
      UtilsAlert.showToast("Order Penjualan Berhasil di buat");
      dashboardPenjualanCt.nomorSoSelected.value = nomorSoFinal;
      dashboardPenjualanCt.nomorSoSelected.refresh();
      Future<bool> prosesGetAllSOHD = dashboardPenjualanCt.getDataAllSOHD();
      bool hasilGetAll = await prosesGetAllSOHD;
      if (hasilGetAll) {
        itemOrderPenjualanCt.totalNetto.value = 0.0;
        itemOrderPenjualanCt.totalNetto.refresh();
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
    UtilsAlert.loadingSimpanData(Get.context!, "Proses simpan...");
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
      // var nomorCbDoFinal = "";
      if (data.isEmpty) {
        tanggalLastFaktur = "";
        nomorDoFinal = "DO${DateFormat('yyyyMM').format(dt)}0001";
        // nomorCbDoFinal = "DO${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        tanggalLastFaktur = data[0]['TANGGAL'];
        // var lastNomorCbDo = data[0]['NOMORCB'];
        var lastNomorDo = data[0]['NOMOR'];

        var filterNmr1 = lastNomorDo.substring(2);
        var filterNmr2 = int.parse(filterNmr1) + 1;
        nomorDoFinal = "DO$filterNmr2";

        // var filterNmrCb1 = lastNomorCbDo.substring(2);
        // var filterNmrCb2 = int.parse(filterNmrCb1) + 1;
        // nomorCbDoFinal = "DO$filterNmrCb2";
      }

      print('tanggal $tanggalLastFaktur');
      print('nomor do $nomorDoFinal');
      // print('nomor cb $nomorCbDoFinal');

      Future<bool> prosesCheckNMRCB = checkNomorCBDO(nomorDoFinal);
      prosesBuatNota = await prosesCheckNMRCB;
    }

    return Future.value(prosesBuatNota);
  }

  Future<bool> checkNomorCBDO(nomorDoFinal) async {
    bool prosescheckcbdo = false;

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'DOHD',
      'kode_cabang': sidebarCt.cabangKodeSelectedSide.value,
    };
    var connect = Api.connectionApi("post", body, "get_last_nomorcb");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var dt = DateTime.now();

    if (valueBody['status'] == true) {
      var nomorSoCBFinal = "";

      if (data.isEmpty) {
        nomorSoCBFinal = "DO${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        var lastNomorCbSo = data[0]['NOMORCB'];
        var filterNmrCbSo1 = lastNomorCbSo.substring(2);
        var filterNmrCbSo2 = int.parse(filterNmrCbSo1) + 1;
        nomorSoCBFinal = "DO$filterNmrCbSo2";
      }

      Future<bool> prosesNomorNota = insertDoBaru(nomorDoFinal, nomorSoCBFinal);
      prosescheckcbdo = await prosesNomorNota;
    }

    return Future.value(prosescheckcbdo);
  }

  Future<bool> insertDoBaru(nomorDoFinal, nomorCbDoFinal) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    var ppnDo = dashboardPenjualanCt.checkIncludePPN.value == false ? "N" : "Y";
    var termValue =
        dashboardPenjualanCt.jatuhTempoBuatOrderPenjualan.value.text == ""
            ? "0"
            : dashboardPenjualanCt.jatuhTempoBuatOrderPenjualan.value.text;

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'DOHD',
      'dohd_cabang': "01",
      'dohd_nomor': "$nomorDoFinal",
      'dohd_noref': dashboardPenjualanCt.refrensiBuatOrderPenjualan.value.text,
      'dohd_tanggal': tanggalNow,
      'dohd_tglinv': tanggalNow,
      'dohd_term': termValue,
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
      UtilsAlert.showToast("Nota Pengiriman Barang berhasil di buat");
      dashboardPenjualanCt.nomorDoSelected.value = nomorDoFinal;
      dashboardPenjualanCt.nomorDoSelected.refresh();
      Future<bool> prosesGetAllDOHD = dashboardPenjualanCt.getDataAllDOHD();
      bool hasilGetAll = await prosesGetAllDOHD;
      if (hasilGetAll) {
        Get.to(DetailNotaPengirimanBarang(dataForm: false),
            duration: Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade);
      }
    } else {
      getAkhirNomorDo();
    }

    return Future.value(true);
  }

  Future<bool> getAkhirNomorSi() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses simpan...");
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'JLHD',
    };
    var connect = Api.connectionApi("post", body, "get_last_faktur");
    bool prosesBuatSI = false;

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var dt = DateTime.now();

    if (valueBody['status'] == true) {
      var tanggalLastFaktur = "";
      var nomorSIFinal = "";
      if (data.isEmpty) {
        tanggalLastFaktur = "";
        nomorSIFinal = "SI${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        tanggalLastFaktur = data[0]['TANGGAL'];
        var lastNomorDo = data[0]['NOMOR'];

        var filterNmr1 = lastNomorDo.substring(2);
        var filterNmr2 = int.parse(filterNmr1) + 1;
        nomorSIFinal = "SI$filterNmr2";
      }

      var nomorAntriLastFaktur = data[0]['NOMORANTRI'];
      var nomorAntriFinal = "";

      var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
      var inputDate = Utility.convertDate4(tanggalLastFaktur);
      if (tanggalNow == inputDate) {
        // print(nomorAntriLastFaktur);
        if (nomorAntriLastFaktur == null || nomorAntriLastFaktur == "") {
          print('nomor antri tidak valid');
          nomorAntriFinal = "${DateFormat('yyyyMMdd').format(dt)}001";
        } else {
          // print('nomor antri valid');
          var ft1 =
              nomorAntriLastFaktur.substring(nomorAntriLastFaktur.length - 3);
          var ft2 = int.parse(ft1) + 1;
          if (ft2 <= 9) {
            nomorAntriFinal = "${DateFormat('yyyyMMdd').format(dt)}00$ft2";
          } else if (ft2 <= 99) {
            nomorAntriFinal = "${DateFormat('yyyyMMdd').format(dt)}0$ft2";
          } else if (ft2 < 999) {
            nomorAntriFinal = "${DateFormat('yyyyMMdd').format(dt)}$ft2";
          }
        }
      } else {
        nomorAntriFinal = "${DateFormat('yyyyMMdd').format(dt)}001";
      }

      // print('tanggal $tanggalLastFaktur');
      // print('nomor si $nomorSIFinal');
      // print('nomor antri si $nomorAntriFinal');

      Future<bool> prosesPenjualan =
          checkNomorCBSI(nomorSIFinal, nomorAntriFinal);
      prosesBuatSI = await prosesPenjualan;
    }

    return Future.value(prosesBuatSI);
  }

  Future<bool> checkNomorCBSI(nomorSIFinal, nomorAntriFinal) async {
    bool prosescheckcbsi = false;

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'kode_cabang': sidebarCt.cabangKodeSelectedSide.value,
    };
    var connect = Api.connectionApi("post", body, "get_last_nomorcb");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    var dt = DateTime.now();

    if (valueBody['status'] == true) {
      var nomorSiCBFinal = "";

      if (data.isEmpty) {
        nomorSiCBFinal = "SI${DateFormat('yyyyMM').format(dt)}0001";
      } else {
        var lastNomorCbSI = data[0]['NOMORCB'];
        var filterNmrCbSi1 = lastNomorCbSI.substring(2);
        var filterNmrCbSi2 = int.parse(filterNmrCbSi1) + 1;
        nomorSiCBFinal = "SI$filterNmrCbSi2";
      }

      Future<bool> prosesPenjualan =
          insertSIBaru(nomorSIFinal, nomorSiCBFinal, nomorAntriFinal);
      prosescheckcbsi = await prosesPenjualan;
    }

    return Future.value(prosescheckcbsi);
  }

  Future<bool> insertSIBaru(
      nomorSIFinal, nomorCbSIFinal, nomorAntriFinal) async {
    bool hasilInsertSI = false;

    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    String statusPilihData =
        dashboardPenjualanCt.pilihDataSelected.value == "Faktur Penjualan"
            ? "SI"
            : "DO";

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'jlhd_cabang': "01",
      'jlhd_nomor': "$nomorSIFinal",
      'jlhd_reff':
          "${dashboardPenjualanCt.refrensiBuatOrderPenjualan.value.text}",
      'jlhd_tanggal': "$tanggalNow",
      'jlhd_tglinv': "$tanggalNow",
      'jlhd_term': "0",
      'jlhd_tgltjp': "$tanggalNow",
      'jlhd_custom': dashboardPenjualanCt.selectedIdPelanggan.value,
      'jlhd_wilayah': dashboardPenjualanCt.wilayahCustomerSelected.value,
      'jlhd_salesm': dashboardPenjualanCt.selectedIdSales.value,
      'jlhd_uang': "RP",
      'jlhd_kurs': "1",
      'jlhd_ket1': "${dashboardPenjualanCt.keteranganSO1.value.text}",
      'jlhd_cb': sidebarCt.cabangKodeSelectedSide.value,
      'jlhd_doe': tanggalDanJam,
      'jlhd_toe': jamTransaksi,
      'jlhd_loe': tanggalDanJam,
      'jlhd_deo': dataInformasiSYSUSER[0],
      'jlhd_nomorcb': "$nomorCbSIFinal",
      'jlhd_id1': dataInformasiSYSUSER[0],
      'jlhd_nopj': dashboardPenjualanCt.noseri1.value.text,
      'jlhd_noseri': dashboardPenjualanCt.noseri2.value.text,
      'jlhd_nomorantri': nomorAntriFinal,
      'jlhd_taxp': 0.0,
      'jlhd_reftr': statusPilihData
    };
    var connect = Api.connectionApi("post", body, "buat_faktur");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);

    if (valueBody['status'] == true) {
      Get.back();
      UtilsAlert.showToast("Faktur Penjualan berhasil di buat");
      dashboardPenjualanCt.nomorFakturPenjualanSelected.value = "";
      dashboardPenjualanCt.nomoFakturPenjualanCbSelected.value = "";

      Future<bool> prosesGetAllFakturPenjualan =
          dashboardPenjualanCt.getDataFakturPenjualan();
      bool hasilGetAll = await prosesGetAllFakturPenjualan;
      if (hasilGetAll) {
        if (statusPilihData == "SI") {
          Get.to(FakturPenjualanSI(dataForm: false),
              duration: Duration(milliseconds: 500),
              transition: Transition.rightToLeftWithFade);
        } else {
          // Get.to(FakturPenjualanSI(dataForm: true),
          //     duration: Duration(milliseconds: 500),
          //     transition: Transition.rightToLeftWithFade);
        }
      }
    } else {
      getAkhirNomorSi();
    }

    return Future.value(hasilInsertSI);
  }
}
