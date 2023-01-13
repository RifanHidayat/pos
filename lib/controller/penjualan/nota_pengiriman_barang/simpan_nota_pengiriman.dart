import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/pos/masuk_keranjang_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'detail_nota__pengiriman_controller.dart';

class SimpanNotaPengirimanController extends GetxController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var notaPengirimanBarangCt = Get.put(DetailNotaPenjualanController());
  var sidebarCt = Get.put(SidebarController());

  void simpanDODT(List dataSelected, qtySebelum, imeiData) async {
    // ambil data asli dohd
    List dataDohdSelected = dashboardPenjualanCt.dohdSelected.value;

    // ambil data asli sodt selected
    var dataSODTSelected = notaPengirimanBarangCt.sodtTerpilih.firstWhere(
        (element) =>
            "${element['GROUP']}${element['BARANG']}${element['NOURUT']}" ==
            "${dataSelected[0]['GROUP']}${dataSelected[0]['KODE']}${dataSelected[0]['NOURUT']}");

    var jumlahPesanFinal = Utility.convertStringRpToDouble(
        notaPengirimanBarangCt.jumlahPesan.value.text);

    if (jumlahPesanFinal <= 0) {
      UtilsAlert.showToast("Gagal simpan barang");
    } else {
      double qtxDODT =
          double.parse('${dataSODTSelected['QTY']}') - jumlahPesanFinal;

      // check stok

      var convertTanggal1 =
          "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
      var tanggalJlhd = "$convertTanggal1 23:59:59";

      Future<List> prosesCheckStok = GetDataController().checkStok(
          dataSelected[0]['GROUP'],
          dataSelected[0]['KODE'],
          tanggalJlhd,
          jumlahPesanFinal,
          sidebarCt.gudangSelectedSide.value);
      List hasilProsesCheckStok = await prosesCheckStok;

      if (!hasilProsesCheckStok[0]) {
        Get.back();
        UtilsAlert.showToast("Gagal simpan barang ${hasilProsesCheckStok[1]}");
      } else {
        UtilsAlert.loadingSimpanData(Get.context!, "Simpan barang...");

        // tanggal
        var dt = DateTime.now();
        var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
        var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
        var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
        var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

        // update data sodt selected
        Future<bool> prosesEditSODT = GetDataController().editQtzSODT(
            dataSODTSelected['NOURUT'],
            dataSODTSelected['NOMOR'],
            '$jumlahPesanFinal');
        bool hasilEditSodt = await prosesEditSODT;

        if (!hasilEditSodt) {
          Get.back();
          UtilsAlert.showToast("Gagal simpan barang");
        } else {
          // update data sohd selected
          Future<bool> prosesEditSOHD = GetDataController().editQtzSOHD(
              dataSODTSelected['NOMOR'], qtySebelum, '$jumlahPesanFinal');
          bool hasilEditSohd = await prosesEditSOHD;

          if (!hasilEditSohd) {
            Get.back();
            UtilsAlert.showToast("Gagal simpan barang");
          } else {
            // INFORMASI NOURUT DAN NOKEY
            String nomorUrut = "";
            String nomorKey = "";
            if (notaPengirimanBarangCt.dodtSelected.isNotEmpty) {
              var getLastList = notaPengirimanBarangCt.dodtSelected.last;

              int getNoUrut = int.parse("${getLastList['NOURUT']}");
              int hitungNoUrut = getNoUrut + 1;

              int getNoKey = int.parse("${getLastList['NOKEY']}");
              int hitungNoKey = getNoKey + 1;

              nomorUrut = "$hitungNoUrut".length == 1
                  ? "0000$hitungNoUrut"
                  : "$hitungNoUrut".length == 2
                      ? "000$hitungNoUrut"
                      : "$hitungNoUrut".length == 3
                          ? "00$hitungNoUrut"
                          : "$hitungNoUrut".length == 4
                              ? "0$hitungNoUrut"
                              : "$hitungNoUrut";
              nomorKey = "$hitungNoKey".length == 1
                  ? "0000$hitungNoKey"
                  : "$hitungNoKey".length == 2
                      ? "000$hitungNoKey"
                      : "$hitungNoKey".length == 3
                          ? "00$hitungNoKey"
                          : "$hitungNoKey".length == 4
                              ? "0$hitungNoKey"
                              : "$hitungNoKey";
            } else {
              nomorUrut = "00001";
              nomorKey = "00001";
            }

            // data cabang selected

            var cabangSelected = sidebarCt.listCabang.firstWhere(
                (element) => element['KODE'] == dataDohdSelected[0]['CB']);
            String gudangSelected = cabangSelected['GUDANG'];

            var dataPersenDiskon =
                notaPengirimanBarangCt.persenDiskonPesanBarang.value.text == ""
                    ? "0"
                    : notaPengirimanBarangCt.persenDiskonPesanBarang.value.text;
            var dataNominalDiskon =
                notaPengirimanBarangCt.nominalDiskonPesanBarang.value.text == ""
                    ? "0,00"
                    : notaPengirimanBarangCt
                        .nominalDiskonPesanBarang.value.text;

            var hargaJualFinal = Utility.convertStringRpToDouble(
                notaPengirimanBarangCt.hargaJualPesanBarang.value.text);
            var persenDiskonPesanBarangFinal =
                Utility.validasiValueDouble(dataPersenDiskon);
            var nominalDiskonPesanBarangFinal =
                Utility.convertStringRpToDouble(dataNominalDiskon);

            // CHECK DATA PROD3

            Future<List> chekingDataProd3 = GetDataController().getSpesifikData(
                "PROD3",
                "NOMOR",
                dataDohdSelected[0]['NOMOR'],
                "get_spesifik_data_transaksi");
            List hasilCheckDataProd3 = await chekingDataProd3;

            List validasiDataProd3 = hasilCheckDataProd3
                .where((element) =>
                    element['NOMOR'] == dataDohdSelected[0]['NOMOR'] &&
                    element['NOURUT'] == dataSelected[0]['NOURUT'])
                .toList();

            if (validasiDataProd3.isEmpty) {
              print('insert prod3');
              // INPUT PROD3
              List dataKirimProd3 = [
                {
                  "cabang_selected": cabangSelected['KODE'],
                  "nomor": dataDohdSelected[0]['NOMOR'],
                  "nomorcb": dataDohdSelected[0]['NOMORCB'],
                  "nourut": nomorUrut,
                  "nokey": nomorKey,
                  "nosub": nomorKey,
                  "noxx": dataSODTSelected["NOMOR"],
                  "noref": "",
                  "ref": "",
                  "custom": dashboardPenjualanCt.selectedIdPelanggan.value,
                  "wilayah": dashboardPenjualanCt.wilayahCustomerSelected.value,
                  "salesm": dashboardPenjualanCt.selectedIdSales.value,
                  "gudang": gudangSelected,
                  "group": dataSelected[0]['GROUP'],
                  "kode": dataSelected[0]['KODE'],
                  "tipe": dataSelected[0]['TIPE'],
                  "qty": jumlahPesanFinal,
                  "sat": dataSelected[0]['SAT'],
                  "harga": hargaJualFinal,
                  "htg": notaPengirimanBarangCt.htgBarangSelected.value,
                  "pak": notaPengirimanBarangCt.pakBarangSelected.value,
                  "hgpak": hargaJualFinal,
                }
              ];
              Future<List> prosesKirimProd3 =
                  GetDataController().kirimProd3(dataKirimProd3);
              List hasilKirimProd3 = await prosesKirimProd3;
              print('status kirim prod3 ${hasilKirimProd3[0]}');
            }

            // CHECK DATA IMEI

            if (imeiData.isNotEmpty && double.parse(qtySebelum) <= 0.0) {
              // INSERT JLIM
              List dataInsertJlim = [
                dataDohdSelected[0]['PK'],
                sidebarCt.cabangKodeSelectedSide.value,
                dataDohdSelected[0]['NOMOR'],
                nomorKey,
                imeiData
              ];
              Future<List> prosesInsertJLIM =
                  GetDataController().insertJLIM(dataInsertJlim);
              List hasilInsertJLIM = await prosesInsertJLIM;
              print("hasil insert jlim $hasilInsertJLIM");

              // INSERT PROD2
              List dataInsertPROD2IMEIX = [
                "01",
                dataDohdSelected[0]['NOMOR'],
                dataDohdSelected[0]['NOMORCB'],
                nomorKey,
                sidebarCt.cabangKodeSelectedSide.value,
                dataDohdSelected[0]['NOMOR'],
                nomorKey,
                dashboardPenjualanCt.selectedIdPelanggan.value,
                dashboardPenjualanCt.wilayahCustomerSelected.value,
                dashboardPenjualanCt.selectedIdSales.value,
                sidebarCt.gudangSelectedSide.value,
                dataSelected[0]['GROUP'],
                dataSelected[0]['KODE'],
                dataSelected[0]['STDJUAL'],
                sidebarCt.cabangKodeSelectedSide.value,
                imeiData
              ];
              Future<List> prosesInsertPROD2 =
                  GetDataController().insertPROD2(dataInsertPROD2IMEIX);
              List hasilInsertPROD2 = await prosesInsertPROD2;
              print("hasil insert prod2 $hasilInsertPROD2");

              // INSERT IMEIX
              Future<List> prosesInsertIMEIX =
                  GetDataController().insertIMEIX(dataInsertPROD2IMEIX);
              List hasilInsertIMEIX = await prosesInsertIMEIX;
              print("hasil insert imeix $hasilInsertIMEIX");
            } else {
              editDataImeiBarang(dataSelected[0], imeiData);
            }

            // UPDATE DATA WARE STOK
            Future<List> prosesUpdateWare = GetDataController().updateWareStok(
                dataSelected[0]['GROUP'],
                dataSelected[0]['KODE'],
                qtySebelum,
                '$jumlahPesanFinal',
                gudangSelected);
            List hasilUpdateWare = await prosesUpdateWare;
            print('status update ware ${hasilUpdateWare[0]}');

            // CHECK DATA DODT

            Future<bool> checkingDataDodt = GetDataController().checkDodt(
                dataDohdSelected[0]['NOMOR'], dataSelected[0]['NOURUT']);
            bool hasilChecking = await checkingDataDodt;
            print('hasil checking dodt $hasilChecking');

            if (!hasilChecking) {
              Map<String, dynamic> body = {
                'database': AppData.databaseSelected,
                'periode': AppData.periodeSelected,
                'stringTabel': 'DODT',
                'dodt_pk': dataDohdSelected[0]['PK'],
                'dodt_cabang': "01",
                'dodt_nomor': dataDohdSelected[0]['NOMOR'],
                'dodt_nourut': nomorUrut,
                'dodt_nokey': nomorKey,
                'dodt_cbxx': "01",
                'dodt_noxx': dataSODTSelected["NOMOR"],
                'dodt_nosub': nomorUrut,
                'dodt_tanggal': tanggalNow,
                'dodt_custom': dashboardPenjualanCt.selectedIdPelanggan.value,
                'dodt_wilayah':
                    dashboardPenjualanCt.wilayahCustomerSelected.value,
                'dodt_salesm': dashboardPenjualanCt.selectedIdSales.value,
                'dodt_gudang': gudangSelected,
                'dodt_group': dataSelected[0]['GROUP'],
                'dodt_barang': dataSelected[0]['KODE'],
                'dodt_qty': jumlahPesanFinal,
                'dodt_qtx': qtxDODT,
                'dodt_qtz': "0",
                'dodt_sat': notaPengirimanBarangCt.typeBarangSelected.value,
                'dodt_uang': "RP",
                'dodt_kurs': "1",
                'dodt_harga': hargaJualFinal,
                'dodt_disc1': persenDiskonPesanBarangFinal,
                'dodt_discd': nominalDiskonPesanBarangFinal,
                'dodt_doe': tanggalDanJam,
                'dodt_toe': jamTransaksi,
                'dodt_loe': tanggalDanJam,
                'dodt_deo': dataInformasiSYSUSER[0],
                'dodt_cb': dataDohdSelected[0]['CB'],
                'dodt_nomorcb': dataDohdSelected[0]['NOMORCB'],
                'dodt_htg': notaPengirimanBarangCt.htgBarangSelected.value,
                'dodt_ptg': "1",
                'dodt_pak': notaPengirimanBarangCt.pakBarangSelected.value,
                'dodt_hgpak': hargaJualFinal,
              };
              var connect = Api.connectionApi("post", body, "insert_dodt");
              var getValue = await connect;
              var valueBody = jsonDecode(getValue.body);
              if (valueBody['status'] == true) {
                Get.back();
                Get.back();
                // Get.back();
                notaPengirimanBarangCt.startload(false);
              }
            } else {
              // update data dodt
              var dataUpdate = {
                "column1": "NOMOR",
                "cari1": dataDohdSelected[0]['NOMOR'],
                "column2": "NOURUT",
                "cari2": dataSelected[0]['NOURUT'],
                'QTY': jumlahPesanFinal,
                'QTX': qtxDODT,
                'HARGA': hargaJualFinal,
                'DISC1': persenDiskonPesanBarangFinal,
                'DISCD': nominalDiskonPesanBarangFinal,
              };
              Future<List> prosesUpdate = GetDataController().editDataGlobal(
                  "DODT", "edit_data_global_transaksi", "2", dataUpdate);

              List hasilProses = await prosesUpdate;

              if (hasilProses[0]) {
                Get.back();
                Get.back();
                Get.back();
                notaPengirimanBarangCt.startload(false);
              } else {
                UtilsAlert.showToast("Gagal edit data barang");
              }
            }
          }
        }
      }
    }
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
