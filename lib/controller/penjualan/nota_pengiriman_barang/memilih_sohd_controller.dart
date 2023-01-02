import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/detail_nota__pengiriman_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

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

      if (hasilProsesSODT.isNotEmpty) {
        detailNotaPengirimanCt.sodtTerpilih.value = hasilProsesSODT;
        detailNotaPengirimanCt.sodtTerpilih.refresh();
        cariBarangProses1(hasilProsesSODT, [], "pilih_so");
      } else {
        Get.back();
        UtilsAlert.showToast("Data so tidak di temukan");
      }
    }
  }

  void cariBarangProses1(List detailSODT, List detailDODT, status) async {
    // tampung group dan kode barang
    List tampungGroupKode = [];
    for (var element in detailSODT) {
      bool statusSelected =
          (element["QTY"] - element["QTZ"]) > 0 ? true : false;
      if (statusSelected) {
        var data = {
          "GROUP": element["GROUP"],
          "KODE": element["BARANG"],
        };
        tampungGroupKode.add(data);
      }
    }
    if (tampungGroupKode.isNotEmpty) {
      // proses cari barang sesuai group dan kode
      Future<List> cariBarangNotaPengiriman =
          GetDataController().cariBarangNotaPengiriman(tampungGroupKode);
      List hasilProsesCariBarang = await cariBarangNotaPengiriman;
      // validasi data final

      Future<List> prosesBarang1 =
          checkingBarang(hasilProsesCariBarang, detailSODT);
      List dataFinalBarangSelected = await prosesBarang1;

      if (detailDODT.isNotEmpty) {
        Future<List> prosesBarang2 =
            checkingBarang2(dataFinalBarangSelected, detailDODT);
        List dataFinalBarangSelected2 = await prosesBarang2;
        prosesFinal(status, dataFinalBarangSelected2);
      } else {
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
    for (var element in hasilProsesCariBarang) {
      for (var element1 in detailSODT) {
        if ("${element['GROUP']}${element['KODE']}" ==
            "${element1['GROUP']}${element1['BARANG']}") {
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
    tampungData = tampungData.toSet().toList();
    return Future.value(tampungData);
  }

  Future<List> checkingBarang2(dataFinalBarangSelected, detailDODT) {
    List tampungData = [];
    for (var element in dataFinalBarangSelected) {
      for (var element1 in detailDODT) {
        if ("${element['GROUP']}${element['KODE']}" ==
            "${element1['GROUP']}${element1['BARANG']}") {
          var data = {
            "GROUP": element["GROUP"],
            "KODE": element["KODE"],
            "NOURUT": element1["NOURUT"],
            "INISIAL": element["INISIAL"],
            "INGROUP": element["INGROUP"],
            "NAMA": element["NAMA"],
            "BARCODE": element["BARCODE"],
            "TIPE": element1["TIPE"],
            "SAT": element1["SAT"],
            "STDJUAL": element1["STDJUAL"],
            "qty_beli": element1["QTY"],
            "DISC1": element1["DISC1"],
            "DISCD": element1["DISCD"],
          };
          tampungData.add(data);
        }
      }
    }
    tampungData = tampungData.toSet().toList();
    return Future.value(tampungData);
  }
}