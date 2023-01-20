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

class SimpanPembayaran extends BaseController {
  var dashboardCt = Get.put(DashbardController());

  void validasiPembayaran(List dataDetailKartu, infoSplitPembayaran) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses pembayaran...");

    Future<bool> prosesInsertPptghd = insertPPTGHD(dataDetailKartu);

    var hasilInsertPptghd = await prosesInsertPptghd;
    if (hasilInsertPptghd == true) {
      Future<bool> prosesPembayaran = updateJlhdPaid();
      var hasilPembayaran = await prosesPembayaran;
      if (hasilPembayaran == true) {
        Get.back();
        Get.back();
        Get.to(
            SelesaiPembayaran(
              dataPembayaran: [],
            ),
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

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  Future<bool> insertPPTGHD(dataDetailKartu) async {
    bool statusBerhasil = false;
    // check last number

    Future<List> checkLastNumber = GlobalController()
        .checkLastNomor("PPTGHD", dashboardCt.cabangKodeSelected.value);
    var resultLastNumber = await checkLastNumber;

    var lastNomor = resultLastNumber[0];
    var lastNomorCb = resultLastNumber[1];

    var totalHarusDibayar = Utility.hitungDetailTotalPos(
        '${dashboardCt.totalNominalDikeranjang.value}',
        dashboardCt.persenDiskonPesanBarang.value.text,
        dashboardCt.ppnPesan.value.text,
        dashboardCt.serviceChargePesan.value.text);

    var convertTotalHarusDibayar = currencyFormatter.format(totalHarusDibayar);
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
          insertPPTGDT(dataDetailKartu, hasilInsert[3], hasilAkhirTotalDibayar);
      bool hasilProsesAwalStart2 = await prosesAwalStart2;
      statusBerhasil = hasilProsesAwalStart2;
    } else {
      UtilsAlert.showToast("Gagal proses 1");
    }

    return Future.value(statusBerhasil);
  }

  Future<bool> insertPPTGDT(
      dataDetailKartu, keyPPTGHD, hasilAkhirTotalDibayar) async {
    // insert pptgdt

    bool statusBerhasil = false;

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
          insertPutang(dataDetailKartu, hasilNokey, hasilAkhirTotalDibayar);
      statusBerhasil = await lanjutProses3;
    } else {
      UtilsAlert.showToast("Gagal proses 2");
    }

    return Future.value(statusBerhasil);
  }

  Future<bool> insertPutang(
      dataDetailKartu, hasilNokey, hasilAkhirTotalDibayar) async {
    bool hasilAkhir = false;
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
          hasilAkhir = true;
        } else {
          hasilAkhir = false;
        }
      }
    } else {
      // update pembayaran tabel putang dan insert
      Future<List> updatePutangDanInsertPembelian = GetDataController()
          .aksiUpdatePutangDanPembayaran(
              dashboardCt.nomorFaktur.value, hasilNokey);
      List hasilUpdatePutang = await updatePutangDanInsertPembelian;
      if (hasilUpdatePutang[0] == true) {
        hasilAkhir = true;
      } else {
        hasilAkhir = false;
      }
    }

    // return Future.value(valueBody['status']);
    return Future.value(hasilAkhir);
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
    String asliTerakhirNomor = "";
    String asliTerakhirNomorCB = "";
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

      asliTerakhirNomor = valueBody['data'][0]['NOMOR'];
      asliTerakhirNomorCB = valueBody['data'][0]['NOMORCB'];

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
    return Future.value(
        [lastNumber, lastNumberCb, asliTerakhirNomor, asliTerakhirNomorCB]);
  }
}
