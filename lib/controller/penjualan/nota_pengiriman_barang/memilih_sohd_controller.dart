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
        for (var element in hasilProsesSODT) {
          List checkingData = detailNotaPengirimanCt.sodtTerpilih
              .where((check) =>
                  "${check['NOMOR']}${check['NOURUT']}" ==
                  "${element["NOMOR"]}${element["NOURUT"]}")
              .toList();
          if (checkingData.isEmpty) {
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
    // print('terpilihhhh sodt ${detailSODT.length}');
    List tampungGroupKode = [];
    for (var element in detailSODT) {
      bool statusSelected = element["QTZ"] == 0 ? true : false;
      if (statusSelected) {
        var data = {
          "GROUP": element["GROUP"],
          "KODE": element["BARANG"],
        };
        tampungGroupKode.add(data);
      }
    }
    // if (detailDODT.isNotEmpty) {
    //   for (var element in detailSODT) {
    //     var data = {
    //       "GROUP": element["GROUP"],
    //       "KODE": element["BARANG"],
    //     };
    //     tampungGroupKode.add(data);
    //   }
    // } else {
    //   for (var element in detailSODT) {
    //     bool statusSelected = element["QTZ"] == 0 ? true : false;
    //     if (statusSelected) {
    //       var data = {
    //         "GROUP": element["GROUP"],
    //         "KODE": element["BARANG"],
    //       };
    //       tampungGroupKode.add(data);
    //     }
    //   }
    // }
    if (tampungGroupKode.isNotEmpty) {
      // proses cari barang sesuai group dan kode
      Future<List> cariBarangNotaPengiriman =
          GetDataController().cariBarangNotaPengiriman(tampungGroupKode);
      List hasilProsesCariBarang = await cariBarangNotaPengiriman;

      // // validasi data final

      // print('hasil proses barang ${hasilProsesCariBarang.length}');

      Future<List> prosesBarang1 =
          checkingBarang(hasilProsesCariBarang, detailSODT);
      List dataFinalBarangSelected = await prosesBarang1;

      prosesFinal(status, dataFinalBarangSelected);

      // if (detailDODT.isNotEmpty) {
      //   Future<List> prosesBarang2 =
      //       checkingBarang2(hasilProsesCariBarang, detailDODT);
      //   List dataFinalBarangSelected2 = await prosesBarang2;
      //   prosesFinal(status, dataFinalBarangSelected2);
      // } else {
      //   print('masuk sini dodt kosong');
      //   prosesFinal(status, dataFinalBarangSelected);
      // }
    } else {
      UtilsAlert.showToast("Data sudah outstanding");
      Get.back();
      Get.back();
      Get.back();
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
    List<String> filterSODT = [];
    for (var element1 in detailSODT) {
      bool statusSelected = element1["QTZ"] == 0 ? true : false;
      if (statusSelected) {
        String validasiData =
            "${element1['GROUP']}-${element1['BARANG']}-${element1['NOURUT']}-${element1['NOMOR']}-${element1['DISC1']}-${element1['DISCD']}";
        filterSODT.add(validasiData);
      }
    }

    // filter data barang
    List dataFinal = [];
    for (var el in filterSODT) {
      List getFilter = el.split("-");
      var getRowBarang = hasilProsesCariBarang.firstWhere((element) =>
          "${element['GROUP']}${element['KODE']}" ==
          "${getFilter[0]}${getFilter[1]}");
      var data = {
        "GROUP": getFilter[0],
        "KODE": getFilter[1],
        "NOURUT": getFilter[2],
        "NAMA": getRowBarang["NAMA"],
        "NOMOR_SO": getFilter[3],
        "TIPE": getRowBarang["TIPE"],
        "SAT": getRowBarang["SAT"],
        "STDJUAL": getRowBarang["STDJUAL"],
        "qty_beli": 0,
        "DISC1": getFilter[4],
        "DISCD": getFilter[5],
      };
      dataFinal.add(data);
    }

    return Future.value(dataFinal);
  }

  Future<List> checkingBarang2(dataFinalBarangSelected, detailDODT) {
    // filter data barang
    List dataFinal = [];
    String nomorSO = "";
    for (var el in dataFinalBarangSelected) {
      List getRowBarang = detailDODT
          .where((element) =>
              "${element['GROUP']}${element['BARANG']}" ==
              "${el['GROUP']}${el['KODE']}")
          .toList();
      if (getRowBarang.isNotEmpty) {
        nomorSO = getRowBarang[0]['NOXX'];
        var data = {
          "GROUP": getRowBarang[0]['GROUP'],
          "KODE": getRowBarang[0]['BARANG'],
          "NOURUT": getRowBarang[0]['NOURUT'],
          "NAMA": el['NAMA'],
          "NOMOR_SO": getRowBarang[0]['NOXX'],
          "TIPE": el['TIPE'],
          "SAT": el['SAT'],
          "STDJUAL": getRowBarang[0]['HARGA'],
          "qty_beli": getRowBarang[0]['QTY'],
          "DISC1": getRowBarang[0]['DISC1'],
          "DISCD": getRowBarang[0]['DISCD'],
        };
        dataFinal.add(data);
      } else {
        var data = {
          "GROUP": el['GROUP'],
          "KODE": el['KODE'],
          "NOURUT": "0000",
          "NAMA": el['NAMA'],
          "NOMOR_SO": nomorSO,
          "TIPE": el['TIPE'],
          "SAT": el['SAT'],
          "STDJUAL": el['STDJUAL'],
          "qty_beli": 0,
          "DISC1": 0,
          "DISCD": 0,
        };
        dataFinal.add(data);
      }
    }

    return Future.value(dataFinal);
  }
}
