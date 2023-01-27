import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/detail_nota__pengiriman_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class MemilihSOHDController extends BaseController {
  var detailNotaPengirimanCt = Get.put(DetailNotaPenjualanController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());

  void mencariDataSODT(List dataSelected) async {
    if (dataSelected.isNotEmpty) {
      // DATA SODT
      UtilsAlert.loadingSimpanData(Get.context!, "Memuat data...");
      Future<List> prosesSodtSelected = GetDataController().getSpesifikData(
          "SODT",
          "NOMOR",
          dataSelected[0]["NOMOR"],
          "get_spesifik_data_transaksi");
      List hasilProsesSODT = await prosesSodtSelected;

      List dataDodt = detailNotaPengirimanCt.dodtSelected.isEmpty
          ? []
          : detailNotaPengirimanCt.dodtSelected;
      if (hasilProsesSODT.isNotEmpty) {
        if (detailNotaPengirimanCt.sodtTerpilih.isEmpty) {
          detailNotaPengirimanCt.sodtTerpilih.value = hasilProsesSODT;
        } else {
          for (var element in hasilProsesSODT) {
            detailNotaPengirimanCt.sodtTerpilih.add(element);
          }
        }
        detailNotaPengirimanCt.sodtTerpilih.refresh();
        cariBarangProses1(
            detailNotaPengirimanCt.sodtTerpilih, dataDodt, "pilih_so");
      } else {
        Get.back();
        UtilsAlert.showToast("Data so tidak di temukan");
      }
    }
  }

  void cariBarangProses1(List detailSODT, List detailDODT, status) async {
    // tampung group dan kode barang
    print('terpilihhhh sodt $detailSODT');
    List tampungGroupKode = [];
    for (var element in detailSODT) {
      // int hitung = element["QTY"] - element["QTZ"];
      // bool statusSelected = hitung > 0 ? true : false;
      // if (statusSelected) {
      //   var data = {
      //     "GROUP": element["GROUP"],
      //     "KODE": element["BARANG"],
      //   };
      //   tampungGroupKode.add(data);
      // }
      var data = {
        "GROUP": element["GROUP"],
        "KODE": element["BARANG"],
      };
      tampungGroupKode.add(data);
    }

    print('list tampung group kode $tampungGroupKode');

    if (tampungGroupKode.isNotEmpty) {
      // proses cari barang sesuai group dan kode
      Future<List> cariBarangNotaPengiriman =
          GetDataController().cariBarangNotaPengiriman(tampungGroupKode);
      List hasilProsesCariBarang = await cariBarangNotaPengiriman;

      // validasi data final

      print('hasil proses barang ${hasilProsesCariBarang.length}');
      print('detail sodt ${detailSODT.length}');

      Future<List> prosesBarang1 =
          checkingBarang(hasilProsesCariBarang, detailSODT);
      List dataFinalBarangSelected = await prosesBarang1;

      if (detailDODT.isNotEmpty) {
        Future<List> prosesBarang2 =
            checkingBarang2(dataFinalBarangSelected, detailDODT);
        List dataFinalBarangSelected2 = await prosesBarang2;
        prosesFinal(status, dataFinalBarangSelected2);
      } else {
        print('masuk sini dodt kosong');
        prosesFinal(status, dataFinalBarangSelected);
      }
    }
  }

  void prosesFinal(status, dataFinal) {
    if (status == "pilih_so") {
      detailNotaPengirimanCt.prosesPilihBarang(dataFinal);
      Get.back();
      Get.back();
      Get.back();
    } else if (status == "load_awal") {
      detailNotaPengirimanCt.prosesPilihBarang(dataFinal);
    }
  }

  Future<List> checkingBarang(hasilProsesCariBarang, detailSODT) {
    List tampungData = [];
    List filter = [];
    for (var element in hasilProsesCariBarang) {
      for (var element1 in detailSODT) {
        if ("${element['GROUP']}${element['KODE']}" ==
            "${element1['GROUP']}${element1['BARANG']}") {
          filter.add("${element['GROUP']}${element['KODE']}");
          var data = {
            "GROUP": element["GROUP"],
            "KODE": element["KODE"],
            "NOURUT": element1["NOURUT"],
            "INISIAL": element["INISIAL"],
            "INGROUP": element["INGROUP"],
            "NAMA": element["NAMA"],
            "BARCODE": element["BARCODE"],
            "TIPE": element["TIPE"],
            "SAT": element["SAT"],
            "STDJUAL": element["STDJUAL"],
            "qty_beli": 0,
            "DISC1": element1["DISC1"],
            "DISCD": element1["DISCD"],
          };
          tampungData.add(data);
        }
      }
    }
    filter = filter.toSet().toList();
    List dataFinal = [];
    for (var dataFilter in filter) {
      var data1 = tampungData.firstWhere(
          (element) => "${element['GROUP']}${element['KODE']}" == dataFilter);
      dataFinal.add(data1);
    }
    return Future.value(dataFinal);
  }

  Future<List> checkingBarang2(dataFinalBarangSelected, detailDODT) {
    List tampungData = [];
    List groupKodeSelected = [];
    for (var element in dataFinalBarangSelected) {
      for (var element1 in detailDODT) {
        if ("${element['GROUP']}${element['KODE']}" ==
            "${element1['GROUP']}${element1['BARANG']}") {
          groupKodeSelected.add("${element["GROUP"]}${element["KODE"]}");
          var data = {
            "GROUP": element["GROUP"],
            "KODE": element["KODE"],
            "NOURUT": element1["NOURUT"],
            "INISIAL": element["INISIAL"],
            "INGROUP": element["INGROUP"],
            "NAMA": element["NAMA"],
            "BARCODE": element["BARCODE"],
            "TIPE": element["TIPE"],
            "SAT": element1["SAT"],
            "STDJUAL": element1["HARGA"],
            "qty_beli": element1["QTY"],
            "DISC1": element1["DISC1"],
            "DISCD": element1["DISCD"],
          };
          tampungData.add(data);
        }
      }
    }
    for (var el in groupKodeSelected) {
      dataFinalBarangSelected.removeWhere(
          (dataBarang) => "${dataBarang['GROUP']}${dataBarang['KODE']}" == el);
    }
    List hasilAll = tampungData + dataFinalBarangSelected;

    return Future.value(hasilAll);
  }
}
