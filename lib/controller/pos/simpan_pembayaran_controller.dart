import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';
import 'package:siscom_pos/screen/pos/selesai_pembayaran.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class SimpanPembayaran extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var splitJumlahBayarCt = Get.put(SplitJumlahBayarController());

  var informasiSelesaiPembayaran = [].obs;

  var statusSelesaiPembayaranSplit = false.obs;

  void validasiPembayaran(List dataDetailKartu, infoSplitPembayaran) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses pembayaran...");
    Future<bool> prosesInsertPptghd = insertPPTGHD(dataDetailKartu);
    var hasilInsertPptghd = await prosesInsertPptghd;
    if (hasilInsertPptghd == true) {
      Future<bool> prosesPembayaran = updateJlhdPaid();
      var hasilPembayaran = await prosesPembayaran;
      if (hasilPembayaran == true) {
        Get.back();
        if (infoSplitPembayaran[0] == true) {
          updatePembayaranSplitSelesai(
              infoSplitPembayaran, dataDetailKartu[0]['tipe_pembayaran']);
        } else {
          var data = [
            {
              'status': false,
              'id_split': 0,
              'total_tagihan_split': 0,
            }
          ];
          informasiSelesaiPembayaran.value = data;
          informasiSelesaiPembayaran.refresh();
        }
        // if (statusSelesaiPembayaranSplit.value == false) {
        // } else {
        //   var data = [
        //     {
        //       'status': infoSplitPembayaran[0],
        //       'id_split': infoSplitPembayaran[1],
        //       'total_tagihan_split': infoSplitPembayaran[2],
        //     }
        //   ];
        //   informasiSelesaiPembayaran.value = data;
        //   informasiSelesaiPembayaran.refresh();
        // }
        Get.to(SelesaiPembayaran(),
            duration: Duration(milliseconds: 400),
            transition: Transition.downToUp);
      } else {
        Get.back();
        UtilsAlert.showToast("Gagal proses pembayaran");
      }
    } else {
      Get.back();
      UtilsAlert.showToast("Gagal proses pembayaran 1");
    }
  }

  void updatePembayaranSplitSelesai(infoSplitPembayaran, tipePembayaran) {
    splitJumlahBayarCt.listPembayaranSplit.forEach((element) {
      if (element['id'] == infoSplitPembayaran[1]) {
        element['tipe_bayar'] = tipePembayaran;
        element['status'] = true;
      }
    });

    splitJumlahBayarCt.listPembayaranSplit.refresh();
    var data = [
      {
        'status': infoSplitPembayaran[0],
        'id_split': infoSplitPembayaran[1],
        'total_tagihan_split': infoSplitPembayaran[2],
      }
    ];
    informasiSelesaiPembayaran.value = data;
    informasiSelesaiPembayaran.refresh();
    UtilsAlert.showToast("Split pembayaran ${infoSplitPembayaran[1]} berhasil");
  }

  // void checkPembayaranSplit() {
  //   var jumlahSplitPembayaran = splitJumlahBayarCt.listPembayaranSplit.length;
  //   var tampung = [];
  //   for (var element in splitJumlahBayarCt.listPembayaranSplit) {
  //     if (element['status'] == true) {
  //       tampung.add(element);
  //     }
  //   }
  //   var hitung = jumlahSplitPembayaran - tampung.length;
  //   if (hitung == 0) {
  //     statusSelesaiPembayaranSplit.value = true;
  //   } else {
  //     statusSelesaiPembayaranSplit.value = false;
  //   }
  // }

  Future<bool> insertPPTGHD(dataDetailKartu) async {
    // check last number
    Future<List> checkLastNumber = checkLastNomor("PPTGHD");
    var resultLastNumber = await checkLastNumber;
    var lastNomor = resultLastNumber[0];
    var lastNomorCb = resultLastNumber[1];

    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PPTGHD',
      'cabang_pptghd': '01',
      'noref_pptghd': '',
      'nomor_pptghd': lastNomor,
      'nomorcb_pptghd': lastNomorCb,
      'cb_pptghd': dashboardCt.cabangKodeSelected.value,
      'ket3_pptghd': 'POS ${dashboardCt.nomorFaktur.value}',
      'ket4_pptghd': '',
      'ket5_pptghd': dataDetailKartu[0]["tipe_pembayaran"],
      'ket6_pptghd': dataDetailKartu[0]["tipe_pembayaran"],
      'saldo_pptghd': dataDetailKartu[0]["total_tagihan"],
      'bayar_pptghd': dataDetailKartu[0]["total_pembayaran"],
      'doe_pptghd': tanggalDanJam,
      'deo_pptghd': dataInformasiSYSUSER[0],
      'id1_pptghd': dataInformasiSYSUSER[0],
      'id3_pptghd': dataInformasiSYSUSER[0],
      'loe_pptghd': tanggalDanJam,
      'toe_pptghd': jamTransaksi,
      'tanggal_pptghd': tanggalNow,
    };
    var connect = Api.connectionApi("post", body, "insert_pptghd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('sampe sioni');
    print(valueBody);
    // var data = valueBody['data'];
    // print('berhasil insert pptghd $data');
    bool statusBerhasil = false;
    if (valueBody['status'] == true) {
      Future<bool> prosesInsertPptgdt =
          insertPPTGDT(dataDetailKartu, valueBody["primaryKey"]);
      statusBerhasil = await prosesInsertPptgdt;
    }
    // else if (valueBody['status'] == false &&
    //     valueBody['message'] == "ulang") {
    // else if (valueBody['status'] == false) {
    //   insertPPTGHD(dataDetailKartu);
    // }
    else {
      UtilsAlert.showToast("Gagal pembayaran 1");
    }

    return Future.value(statusBerhasil);
  }

  Future<bool> insertPPTGDT(dataDetailKartu, pkNumber) async {
    // check last number
    Future<List> checkLastNumber = checkLastNomor("PPTGDT");
    var resultLastNumber = await checkLastNumber;
    var lastNomor = resultLastNumber[0];
    var lastNomorCb = resultLastNumber[1];

    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PPTGDT',
      'pk_pptgdt': pkNumber,
      'cabang_pptgdt': '01',
      'nokey_pptgdt': '00001',
      'cbxx_pptgdt': '01',
      'salesm_pptgdt': dashboardCt.kodePelayanSelected.value,
      'custom_pptgdt': dashboardCt.customSelected.value,
      'wilayah_pptgdt': dashboardCt.wilayahCustomerSelected.value,
      'nomor_pptgdt': lastNomor,
      'nomorcb_pptgdt': lastNomorCb,
      'noxx_pptgdt': dashboardCt.nomorFaktur.value,
      'nosi_pptgdt': dashboardCt.nomorFaktur.value,
      'ref_pptgdt': '',
      'tbayar_pptgdt': '01',
      'noref_pptgdt': '',
      'nogiro_pptgdt': '',
      'saldo_pptgdt': dataDetailKartu[0]["total_tagihan"],
      'appcode_pptgdt': dataDetailKartu[0]["app_code"],
      'namakartu_pptgdt': dataDetailKartu[0]["nama_kartu"],
      'nomorkartu_pptgdt': dataDetailKartu[0]["nomor_kartu"],
      'keterangankartu_pptgdt': dataDetailKartu[0]["keterangab_kartu"],
      'ket_pptgdt': 'POS ${dashboardCt.nomorFaktur.value}',
      'doe_pptgdt': tanggalDanJam,
      'deo_pptgdt': dataInformasiSYSUSER[0],
      'loe_pptgdt': tanggalDanJam,
      'toe_pptgdt': jamTransaksi,
      'mata_pptgdt': 'RP',
      'cb_pptgdt': dashboardCt.cabangKodeSelected.value,
      'uang_pptgdt': 'RP',
      'kurs_pptgdt': '1',
      'kurslama_pptgdt': '1',
      'kursbaru_pptgdt': '1',
      'jtgiro_pptgdt': tanggalDanJam,
      'tgltjp_pptgdt': tanggalDanJam,
      'bayar_pptgdt': dataDetailKartu[0]["total_pembayaran"],
      'byr_pptgdt': dataDetailKartu[0]["total_pembayaran"],
      'produk_pptgdt': '',
    };
    var connect = Api.connectionApi("post", body, "insert_pptgdt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    bool statusBerhasil = false;
    if (valueBody['status'] == true) {
      print('berhasil insert pptgdt ${valueBody["data"]}');
      Future<bool> prosesInsertPutang = insertPutang(dataDetailKartu);
      statusBerhasil = await prosesInsertPutang;
    } else {
      UtilsAlert.showToast('gagal proses 2');
    }
    return Future.value(statusBerhasil);
  }

  Future<bool> insertPutang(dataDetailKartu) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PUTANG',
      'cabang_putang': '01',
      'cbxx_putang': '01',
      'salesm_putang': dashboardCt.kodePelayanSelected.value,
      'custom_putang': dashboardCt.customSelected.value,
      'wilayah_putang': dashboardCt.wilayahCustomerSelected.value,
      'nomor_putang': dashboardCt.nomorFaktur.value,
      'nomorcb_putang': dashboardCt.nomorCbLastSelected.value,
      'noxx_putang': dashboardCt.nomorFaktur.value,
      'noref_putang': '',
      'ref_putang': '',
      'nogiro_putang': '',
      'nokey_putang': '00001',
      'cb_putang': dashboardCt.cabangKodeSelected.value,
      'tbayar_putang': '',
      'ceer_putang': dataDetailKartu[0]["total_pembayaran"],
      'doe_putang': tanggalDanJam,
      'uang_putang': 'RP',
      'kurs_putang': '1',
      'deo_putang': dataInformasiSYSUSER[0],
      'loe_putang': tanggalDanJam,
      'toe_putang': jamTransaksi,
      'sign_putang': '',
      'tgljtp_putang': tanggalDanJam,
      'tanggal_putang': tanggalDanJam,
      'flag_putang': 'Z',
      'tgl_putang': tanggalNow,
      'jtgiro_putang': tanggalDanJam,
      'produk_putang': '',
      'reftr_putang': '',
    };
    var connect = Api.connectionApi("post", body, "insert_putang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print("berhasil insert putang ${valueBody['data']}");
    return Future.value(valueBody['status']);
  }

  Future<bool> updateJlhdPaid() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'JLHD',
      'nomor_faktur': dashboardCt.nomorFaktur.value,
    };
    var connect = Api.connectionApi("post", body, "update_jlhd_pembayaran");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<List> checkLastNomor(tabel) async {
    String lastNumber = "";
    String lastNumberCb = "";
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabel,
      'kode_cabang': dashboardCt.cabangKodeSelected.value,
    };
    var connect = Api.connectionApi("post", body, "get_last_number_pembayaran");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (valueBody['status'] == true) {
      var fltr1a = "";
      var fltr3a = "";

      var dt = DateTime.now();
      var tahunBulan = "${DateFormat('yyyyMM').format(dt)}";
      if (data.isNotEmpty) {
        var tp1 = valueBody['data'][0]['NOMOR'];
        var fltr1 = tp1.substring(0, 2);
        var fltr2 = tp1.substring(8, 12);
        var tambah = int.parse(fltr2) + 1;
        var fltr3 = "$tambah".length == 3
            ? "0$tambah"
            : "$tambah".length == 2
                ? "00$tambah"
                : "$tambah".length == 1
                    ? "000$tambah"
                    : "$tambah";

        lastNumber = "$fltr1$tahunBulan$fltr3";

        var tp1a = valueBody['data'][0]['NOMORCB'];
        fltr1a = tp1a.substring(0, 2);
        var fltr2a = tp1a.substring(8, 12);
        var tambaha = int.parse(fltr2a) + 1;
        fltr3a = "$tambaha".length == 3
            ? "0$tambah"
            : "$tambah".length == 2
                ? "00$tambah"
                : "$tambah".length == 1
                    ? "000$tambah"
                    : "$tambah";
        lastNumberCb = "$fltr1a$tahunBulan$fltr3a";
      } else {
        var kode = "DB";
        var nomor = "0001";
        lastNumber = "$kode$tahunBulan$nomor";
        lastNumberCb = "$kode$tahunBulan$nomor";
      }
    } else {
      UtilsAlert.showToast(valueBody['message']);
    }
    return Future.value([lastNumber, lastNumberCb]);
  }
}
