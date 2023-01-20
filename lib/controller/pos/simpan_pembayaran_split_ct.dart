import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';
import 'package:siscom_pos/screen/pos/selesai_pembayaran.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class SimpanPembayaranSplit extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var splitJumlahBayarCt = Get.put(SplitJumlahBayarController());

  var informasiSelesaiPembayaran = [].obs;

  var statusSelesaiPembayaranSplit = false.obs;

  void validasiPembayaranSplit(
      List dataDetailKartu, infoSplitPembayaran) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses pembayaran...");

    // check pptgdt

    Future<List> checkingPPTGDT = GetDataController().getSpesifikData("PPTGDT",
        "NOXX", dashboardCt.nomorFaktur.value, "get_spesifik_data_transaksi");
    List hasilChecking = await checkingPPTGDT;
    if (hasilChecking.isEmpty) {
      Future<bool> prosesAwalStart = prosesAwal(dataDetailKartu);
      bool hasilProsesAwal = await prosesAwalStart;
      // PROSES AWAL SPLIT
      if (hasilProsesAwal) {
        updatePembayaranSplitSelesai(
            infoSplitPembayaran, dataDetailKartu[0]['tipe_pembayaran']);
      } else {
        UtilsAlert.showToast("Gagal split pembayaran");
      }
    } else {
      // PROSES LANJUTAN SPLIT
      Future<bool> prosesAwalSelanjutnya =
          prosesSelanjutnya(dataDetailKartu, infoSplitPembayaran);
      bool hasilProsesSelanjutnya = await prosesAwalSelanjutnya;
      if (hasilProsesSelanjutnya) {
        if (infoSplitPembayaran[3] == false) {
          updatePembayaranSplitSelesai(
              infoSplitPembayaran, dataDetailKartu[0]['tipe_pembayaran']);
        } else {
          var infoPembayaran = [
            {
              'status': infoSplitPembayaran[0],
              'id_split': infoSplitPembayaran[1],
              'total_tagihan_split': infoSplitPembayaran[2],
              'status_selesai_split': true,
            }
          ];
          Get.back();
          Get.back();
          Get.to(
              SelesaiPembayaran(
                dataPembayaran: infoPembayaran,
              ),
              duration: Duration(milliseconds: 400),
              transition: Transition.downToUp);
        }
      } else {
        UtilsAlert.showToast("Gagal split pembayaran");
      }
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
    var infoPembayaran = [
      {
        'status': infoSplitPembayaran[0],
        'id_split': infoSplitPembayaran[1],
        'total_tagihan_split': infoSplitPembayaran[2],
        'status_selesai_split': false,
      }
    ];

    Get.back();
    Get.back();
    Get.to(
        SelesaiPembayaran(
          dataPembayaran: infoPembayaran,
        ),
        duration: Duration(milliseconds: 400),
        transition: Transition.downToUp);
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  Future<bool> prosesAwal(dataDetailKartu) async {
    bool start1 = false;
    // insert pptghd
    Future<List> checkLastNumber = GlobalController()
        .checkLastNomor("PPTGHD", dashboardCt.cabangKodeSelected.value);
    var resultLastNumber = await checkLastNumber;

    var lastNomor = resultLastNumber[0];
    var lastNomorCb = resultLastNumber[1];

    var convertTotalHarusDibayar =
        currencyFormatter.format(splitJumlahBayarCt.totalHarusDibayar.value);
    var hasilAkhirTotalDibayar =
        Utility.convertStringRpToDouble(convertTotalHarusDibayar);

    List dataInsert = [
      lastNomor,
      lastNomorCb,
      dashboardCt.cabangKodeSelected.value,
      dashboardCt.nomorFaktur.value,
      dataDetailKartu[0]["tipe_pembayaran"],
      dataDetailKartu[0]["tipe_pembayaran"],
      hasilAkhirTotalDibayar,
      dataDetailKartu[0]["total_tagihan"],
    ];

    Future<List> prosesInsertPPTGHD =
        GetDataController().insertPPTGHD(dataInsert);
    List hasilInsert = await prosesInsertPPTGHD;

    if (hasilInsert[0] == true) {
      Future<bool> prosesAwalStart2 =
          awalStart2(dataDetailKartu, hasilInsert[3], hasilAkhirTotalDibayar);
      bool hasilProsesAwalStart2 = await prosesAwalStart2;
      start1 = hasilProsesAwalStart2;
    } else {
      UtilsAlert.showToast("Gagal proses 1");
    }

    return Future.value(start1);
  }

  Future<bool> awalStart2(
      dataDetailKartu, keyPPTGHD, hasilAkhirTotalDibayar) async {
    bool start2 = false;

    // insert pptgdt

    Future<List> checkLastNumber = GlobalController()
        .checkLastNomor("PPTGDT", dashboardCt.cabangKodeSelected.value);
    var resultLastNumber = await checkLastNumber;

    var lastNomor = resultLastNumber[0];
    var lastNomorCb = resultLastNumber[1];

    Future<String> checkNokey =
        GlobalController().checkNokey("PPTGDT", "NOXX", resultLastNumber[0]);

    String hasilNokey = await checkNokey;

    List dataInsert = [
      keyPPTGHD,
      hasilNokey,
      dashboardCt.kodePelayanSelected.value,
      dashboardCt.customSelected.value,
      dashboardCt.wilayahCustomerSelected.value,
      lastNomor,
      lastNomorCb,
      dashboardCt.nomorFaktur.value,
      dashboardCt.nomorFaktur.value,
      hasilAkhirTotalDibayar,
      dataDetailKartu[0]["app_code"],
      dataDetailKartu[0]["nama_kartu"],
      dataDetailKartu[0]["nomor_kartu"],
      dataDetailKartu[0]["keterangab_kartu"],
      dashboardCt.nomorFaktur.value,
      dashboardCt.cabangKodeSelected.value,
      dataDetailKartu[0]["total_tagihan"],
      dataDetailKartu[0]["total_pembayaran"],
    ];

    Future<List> prosesInsertPPTGDT =
        GetDataController().insertPPTGDT(dataInsert);
    List hasilInsert = await prosesInsertPPTGDT;

    if (hasilInsert[0] == true) {
      Future<bool> lanjutProses3 =
          awalStart3(dataDetailKartu, hasilNokey, hasilAkhirTotalDibayar);
      start2 = await lanjutProses3;
    } else {
      UtilsAlert.showToast("Gagal proses 2");
    }

    return Future.value(start2);
  }

  Future<bool> awalStart3(
      dataDetailKartu, hasilNokey, hasilAkhirTotalDibayar) async {
    bool start3 = false;

    // CHECK PUTANG

    Future<List> checkingPutang = GetDataController().getSpesifikData("PUTANG",
        "NOMOR", dashboardCt.nomorFaktur.value, "get_spesifik_data_transaksi");
    List prosesCheckPutang = await checkingPutang;

    if (prosesCheckPutang.isEmpty) {
      var dataInsert = [
        dashboardCt.kodePelayanSelected.value,
        dashboardCt.customSelected.value,
        dashboardCt.wilayahCustomerSelected.value,
        dashboardCt.nomorFaktur.value,
        dashboardCt.nomorCbLastSelected.value,
        dashboardCt.nomorFaktur.value,
        dashboardCt.cabangKodeSelected.value,
        hasilAkhirTotalDibayar,
        0,
        dataDetailKartu[0]["total_tagihan"],
      ];

      Future<List> prosesInsertPutang =
          GetDataController().insertPutang(dataInsert);
      List hasilInsertPutang = await prosesInsertPutang;

      if (hasilInsertPutang[0] == true) {
        // update pembayaran tabel putang dan insert
        Future<List> updatePutangDanInsertPembelian = GetDataController()
            .aksiUpdatePutangDanPembayaran(
                dashboardCt.nomorFaktur.value, hasilNokey);
        List hasilUpdatePutang = await updatePutangDanInsertPembelian;
        if (hasilUpdatePutang[0] == true) {
          start3 = true;
        } else {
          start3 = false;
        }
      }
    } else {
      // update pembayaran tabel putang dan insert
      Future<List> updatePutangDanInsertPembelian = GetDataController()
          .aksiUpdatePutangDanPembayaran(
              dashboardCt.nomorFaktur.value, hasilNokey);
      List hasilUpdatePutang = await updatePutangDanInsertPembelian;
      if (hasilUpdatePutang[0] == true) {
        start3 = true;
      } else {
        start3 = false;
      }
    }

    return Future.value(start3);
  }

  Future<bool> prosesSelanjutnya(dataDetailKartu, infoSplitPembayaran) async {
    bool start1 = false;
    // print('detail kartu proses lanjutan $dataDetailKartu');
    // print('info split pembayaran lanjutan $infoSplitPembayaran');
    // check pptgdt

    Future<List> checkingPPTGDT = GetDataController().getSpesifikData("PPTGDT",
        "NOXX", dashboardCt.nomorFaktur.value, "get_spesifik_data_transaksi");
    List hasilChecking = await checkingPPTGDT;

    var pkPPTGHD = hasilChecking[0]["PK"];

    // check data pptghd

    Future<List> checkingPPTGHD = GetDataController().getSpesifikData(
        "PPTGHD", "PK", "$pkPPTGHD", "get_spesifik_data_transaksi");
    List hasilCheckingPPTGHD = await checkingPPTGHD;

    // update pptghd
    double saldo = double.parse("${hasilCheckingPPTGHD[0]["SALDO"]}");
    double bayar = double.parse("${hasilCheckingPPTGHD[0]["BAYAR"]}");
    double hitungBayar =
        bayar + double.parse("${dataDetailKartu[0]['total_tagihan']}");

    // print('saldo pptghd $saldo');
    // print('bayar pptghd $bayar');
    // print('hitung akhir bayar $hitungBayar');

    var dataUpdate = {
      "column1": "PK",
      "cari1": "$pkPPTGHD",
      "BAYAR": hitungBayar,
    };

    Future<List> prosesUpdatePPTGHD = GetDataController().editDataGlobal(
        "PPTGHD", "edit_data_global_transaksi", "1", dataUpdate);
    List hasilUpdate = await prosesUpdatePPTGHD;

    if (hasilUpdate[0] == true) {
      Future<bool> prosesStart2 =
          prosesLanjutanStart2(dataDetailKartu, infoSplitPembayaran);
      start1 = await prosesStart2;
    } else {
      UtilsAlert.showToast("Gagal proses pembayaran 1");
    }

    // print('informasi PPTGHD $hasilCheckingPPTGHD');

    return Future.value(start1);
  }

  Future<bool> prosesLanjutanStart2(
      dataDetailKartu, infoSplitPembayaran) async {
    bool start2 = false;

    // check pptgdt last
    Future<List> prosesCheck = GetDataController().getSpesifikData("PPTGDT",
        "NOXX", dashboardCt.nomorFaktur.value, "get_spesifik_data_transaksi");
    List hasilProses = await prosesCheck;

    if (hasilProses.isNotEmpty) {
      var dataLast = hasilProses.last;
      double saldoPPTGDT = double.parse("${dataLast["SALDO"]}");
      double bayarPPTGDT = double.parse("${dataLast["BAYAR"]}");
      double hitungSaldo = saldoPPTGDT - bayarPPTGDT;

      var nokeyLanjutan = int.parse("${dataLast["NOKEY"]}") + 1;

      var finaNokey = "$nokeyLanjutan".length == 1
          ? "0000$nokeyLanjutan"
          : "$nokeyLanjutan".length == 2
              ? "000$nokeyLanjutan"
              : "$nokeyLanjutan".length == 3
                  ? "00$nokeyLanjutan"
                  : "$nokeyLanjutan".length == 4
                      ? "0$nokeyLanjutan"
                      : "$nokeyLanjutan";

      List dataInsert = [
        dataLast["PK"],
        finaNokey,
        dataLast["SALESM"],
        dataLast["CUSTOM"],
        dataLast["WILAYAH"],
        dataLast["NOMOR"],
        dataLast["NOMORCB"],
        dataLast["NOXX"],
        dataLast["NOSI"],
        hitungSaldo,
        dataDetailKartu[0]["app_code"],
        dataDetailKartu[0]["nama_kartu"],
        dataDetailKartu[0]["nomor_kartu"],
        dataDetailKartu[0]["keterangab_kartu"],
        dataLast["NOXX"],
        dataLast["CB"],
        dataDetailKartu[0]["total_tagihan"],
        dataDetailKartu[0]["total_pembayaran"],
      ];

      Future<List> prosesInsertPPTGDT =
          GetDataController().insertPPTGDT(dataInsert);
      List hasilInsert = await prosesInsertPPTGDT;

      print('hasil insert pptgdt $hasilInsert');

      if (hasilInsert[0] == true) {
        Future<bool> lanjutProsesLanjutan3 =
            prosesLanjutan3(dataLast["NOXX"], finaNokey);
        start2 = await lanjutProsesLanjutan3;
      } else {
        UtilsAlert.showToast("Gagal proses 2");
      }
    } else {
      UtilsAlert.showToast("Gagal proses pembayaran 2");
    }

    return Future.value(start2);
  }

  Future<bool> prosesLanjutan3(nomor, finaNokey) async {
    bool start3 = false;

    Future<List> updatePutangDanInsertPembelian =
        GetDataController().aksiUpdatePutangDanPembayaran(nomor, finaNokey);

    List hasilUpdatePutang = await updatePutangDanInsertPembelian;

    print('hasil insert putang $hasilUpdatePutang');

    if (hasilUpdatePutang[0] == true) {
      start3 = true;
    } else {
      start3 = false;
    }

    return Future.value(start3);
  }
}
