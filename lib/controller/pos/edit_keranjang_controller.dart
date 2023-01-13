import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/masuk_keranjang_controller.dart';
import 'package:siscom_pos/controller/pos/perhitungan_controller.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class EditKeranjangController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var perhitunganCt = Get.put(PerhitunganController());

  void editKeranjang(produkSelected, type, List listImei) {
    UtilsAlert.loadingSimpanData(Get.context!, "Edit data");
    // update data barang
    var filterData = dashboardCt.listKeranjangArsip.value.firstWhere(
        (element) =>
            "${element["GROUP"]}${element["BARANG"]}" ==
            "${produkSelected[0]["GROUP"]}${produkSelected[0]["KODE"]}");

    var filter1 = dashboardCt.hargaJualPesanBarang.value.text;
    var filter2 = filter1.replaceAll("Rp", "");
    var filter3 = filter1.replaceAll(" ", "");
    var filter4 = filter2.replaceAll(".", "");
    var hrgJualEditFinal = int.parse(filter4);

    var filterJml1 = dashboardCt.jumlahPesan.value.text;
    var filterJml2 = filterJml1.replaceAll(",", ".");
    var finalQtyEdit = double.parse(filterJml2);
    print(finalQtyEdit);
    print('validasi edit');

    if (finalQtyEdit <= 0) {
      Get.back();
      Get.back();
      UtilsAlert.showToast("Quantity tidak valid");
    } else {
      editJldtBarang(
          filterData, hrgJualEditFinal, finalQtyEdit, type, listImei);
    }
  }

  editJldtBarang(
      filterData, hrgJualEditFinal, finalQtyEdit, type, List listImei) {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var checkFilterDiscd = dashboardCt.hargaDiskonPesanBarang.value.text == ""
        ? "0"
        : dashboardCt.hargaDiskonPesanBarang.value.text;
    var filterDiscd = checkFilterDiscd.replaceAll(".", "");

    var checkFilterDisc1 = dashboardCt.persenDiskonPesanBarang.value.text == ""
        ? "0"
        : dashboardCt.persenDiskonPesanBarang.value.text;
    var flt1 = checkFilterDisc1.replaceAll(',', '.');
    var filterDisc1 = flt1.replaceAll('.', '.');

    if (listImei.isNotEmpty) {
      editDataImeiBarang(filterData, listImei);
    }

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'jldt_pk': filterData["PK"],
      'jldt_nourut': filterData["NOURUT"],
      'jldt_tanggal': tanggalNow,
      'jldt_tgl': tanggalNow,
      'jldt_doe': tanggalDanJam,
      'jldt_toe': jamTransaksi,
      'jldt_loe': tanggalDanJam,
      'jldt_qty': finalQtyEdit,
      'jldt_harga': hrgJualEditFinal,
      'jldt_disc1': filterDisc1,
      'jldt_discd': filterDiscd,
      'jldt_htg': dashboardCt.htgUkuran.value,
      'valuepak': dashboardCt.pakUkuran.value,
      'jldt_keterangan': dashboardCt.catatanPembelian.value.text,
    };
    var connect = Api.connectionApi("post", body, "edit_jldt");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          filterData["QTY"] = finalQtyEdit;
          filterData["HARGA"] = hrgJualEditFinal;
          filterData["HTG"] = dashboardCt.htgUkuran.value;
          filterData["PAK"] = dashboardCt.pakUkuran.value;
          dashboardCt.catatanPembelian.value.text = "";
          UtilsAlert.showToast("${valueBody['message']}");
          var dataKeranjangEdit = dashboardCt.listKeranjangArsip.value
              .firstWhere(
                  (element) => element["NOURUT"] == filterData["NOURUT"]);
          dataKeranjangEdit["TANGGAL"] = tanggalNow;
          dataKeranjangEdit["TGL"] = tanggalNow;
          dataKeranjangEdit["QTY"] = finalQtyEdit;
          dataKeranjangEdit["HARGA"] = hrgJualEditFinal;
          dataKeranjangEdit["DISC1"] =
              dashboardCt.persenDiskonPesanBarang.value.text;
          dataKeranjangEdit["DISCD"] = double.parse(filterDiscd);
          dataKeranjangEdit["DOE"] = tanggalDanJam;
          dataKeranjangEdit["TOE"] = jamTransaksi;
          dataKeranjangEdit["LOE"] = tanggalDanJam;
          dataKeranjangEdit["HTG"] = dashboardCt.htgUkuran.value;
          dataKeranjangEdit["PAK"] = dashboardCt.pakUkuran.value;
          dataKeranjangEdit["KETERANGAN"] =
              dashboardCt.catatanPembelian.value.text;
          dashboardCt.listKeranjangArsip.refresh();
          dashboardCt.hitungAllArsipMenu();
          if (type == 'edit_dari_scanbarcode') {
            Get.back();
            Get.back();
            dashboardCt.aksiPilihKategoriBarang();
            Get.to(
              RincianPemesanan(),
            );
          } else {
            Get.back();
            Get.back();
            Get.back();
            Get.back();
            dashboardCt.aksiPilihKategoriBarang();
            Get.to(
              RincianPemesanan(),
            );
          }
        } else {
          UtilsAlert.showToast(valueBody['message']);
          Get.back();
          Get.back();
        }
      }
    });
  }

  void editDataImeiBarang(filterData, List listImei) async {
    // print('data selected $filterData');
    // DATA IMEI SEBELUM EDIT
    Future<List> dataImeiSebelumEdit = GetDataController().getSpesifikData(
        "PROD2", "NOMOR", filterData["NOMOR"], "get_spesifik_data_transaksi");
    List hasilImeiEdit = await dataImeiSebelumEdit;
    if (hasilImeiEdit.isNotEmpty) {
      List tampungImeiSebelumEdit = [];
      for (var element in hasilImeiEdit) {
        tampungImeiSebelumEdit.add(element["IMEI"]);
      }
      // HAPUS DATA PROD2
      var dataUpdate1 = {"column1": "NOMOR", "delete1": filterData["NOMOR"]};
      Future<List> hapusProd2 = GetDataController()
          .hapusGlobal("PROD2", "hapus_global_transaksi", "1", dataUpdate1);
      List hapusDataProd2 = await hapusProd2;
      if (hapusDataProd2.isNotEmpty) {
        print('prod2 berhasil di hapus');
        // HAPUS DATA JLIM
        var dataUpdate1 = {"column1": "NOMOR", "delete1": filterData["NOMOR"]};
        Future<List> hapusJlim = GetDataController()
            .hapusGlobal("JLIM", "hapus_global_transaksi", "1", dataUpdate1);
        List hapusDataJlim = await hapusJlim;
        if (hapusDataJlim.isNotEmpty) {
          print('jlim berhasil di hapus');
          for (var element in tampungImeiSebelumEdit) {
            Future<List> lastDataPembelianImei = GetDataController()
                .getSpesifikData(
                    "PROD2", "IMEI", element, "get_spesifik_data_transaksi");
            List dataLastPembelian = await lastDataPembelianImei;
            var dataUpdate = {
              "column1": "NOMOR",
              "cari1": filterData["NOMOR"],
              "column2": "IMEI",
              "cari2": element,
              "NOMOR": dataLastPembelian[0]['NOMOR'],
              "NOMORCB": dataLastPembelian[0]['NOMORCB'],
              "NOKEY": dataLastPembelian[0]['NOKEY'],
              "GUDANG": dataLastPembelian[0]['GUDANG'],
              "HARGA": dataLastPembelian[0]['HARGA'],
              "FLAG": "3"
            };
            GetDataController().editDataGlobal(
                "IMEIX", "edit_data_global_transaksi", "2", dataUpdate);
          }
          print('selesai update data flag imei sebelum edit');
          MasukKeranjangController().insertJlim(
              [filterData],
              filterData["NOKEY"],
              filterData["NOURUT"],
              filterData["HARGA"],
              filterData["QTY"],
              listImei);
          MasukKeranjangController().insertProd2(
              [filterData],
              filterData["NOKEY"],
              filterData["NOURUT"],
              filterData["HARGA"],
              filterData["QTY"],
              listImei);
          for (var element in listImei) {
            var dataUpdate = {
              "column1": "IMEI",
              "cari1": element,
              "NOMOR": filterData["NOMOR"],
              "NOMORCB": filterData["NOMORCB"],
              "NOKEY": filterData["NOKEY"],
              "CBXX": filterData["CB"],
              "NOXX": filterData["NOMOR"],
              "NOSUB": filterData["NOKEY"],
              "HARGA": filterData["HARGA"],
              "FLAG": "7"
            };
            GetDataController().editDataGlobal(
                "IMEIX", "edit_data_global_transaksi", "1", dataUpdate);
          }
        }
      }
    }
  }
}
