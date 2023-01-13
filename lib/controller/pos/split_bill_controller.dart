import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/buat_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/hapus_jldt_controller.dart';
import 'package:siscom_pos/controller/pos/masuk_keranjang_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_faktur_controller.dart';
import 'package:siscom_pos/utils/toast.dart';

class SplitBillController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var hapusJldtCt = Get.put(HapusJldtController());
  var simpanFakturCt = Get.put(SimpanFakturController());
  var masukKeranjangCt = Get.put(MasukKeranjangController());
  var buatFakturCt = Get.put(BuatFakturController());

  var dataKeranjangScreenSplitBill = [].obs;

  var jumlahBarangKeranjangAsli = 0.obs;

  void loadDataKeranjang() async {
    Future<bool> checkKeranjang = isiKeranjangDicheck();
    var hasilCheck = await checkKeranjang;
    if (hasilCheck == true) {
      var tampung = [];
      for (var element in dashboardCt.listKeranjangArsip.value) {
        var data = {
          'NAMA': element['NAMA'],
          'NOURUT': element['NOURUT'],
          'PK': element['PK'],
          'NOMOR': element['NOMOR'],
          'QTY': element['QTY'],
          'HARGA': element['HARGA'],
          'HTG': element['HTG'],
          'PAK': element['PAK'],
          'GROUP': element['GROUP'],
          'GUDANG': element['GUDANG'],
          'BARANG': element['BARANG'],
          'DISC1': element['DISC1'],
          'DISCD': element['DISCD'],
          'status': false,
        };
        tampung.add(data);
      }
      jumlahBarangKeranjangAsli.value =
          dashboardCt.listKeranjangArsip.value.length;
      dataKeranjangScreenSplitBill.value = tampung;
      refreshAll();
    } else {
      UtilsAlert.showToast('Keranjang tidak valid untuk split bill');
      Get.back();
    }
  }

  Future<bool> isiKeranjangDicheck() {
    bool statusHasil = false;
    if (dashboardCt.listKeranjangArsip.value.length < 2) {
      statusHasil = false;
    } else {
      statusHasil = true;
    }
    return Future.value(statusHasil);
  }

  void chooseForSplit(barang) {
    dataKeranjangScreenSplitBill.value.forEach((element) {
      if (element['NOURUT'] == barang['NOURUT']) {
        element['status'] = !element['status'];
      }
    });
    refreshAll();
  }

  void proses1SplitBill() async {
    UtilsAlert.loadingSimpanData(Get.context!, 'Proses split bill...');
    List tampungSelectedSplit = dataKeranjangScreenSplitBill
        .where((element) => element['status'] == true)
        .toList();
    var hitungSisaBarang =
        jumlahBarangKeranjangAsli - tampungSelectedSplit.length;
    if (hitungSisaBarang <= 0) {
      UtilsAlert.showToast('Gagal split bill');
      Get.back();
    } else {
      var dataKeranjangTerpilihSplit = dashboardCt.listKeranjangArsip
          .firstWhere((element) =>
              element['NOURUT'] == tampungSelectedSplit[0]['NOURUT']);
      var dataSelected = [
        dataKeranjangTerpilihSplit['NOURUT'],
        dataKeranjangTerpilihSplit['PK'],
        dataKeranjangTerpilihSplit['NOMOR'],
        dataKeranjangTerpilihSplit['GUDANG'],
        dataKeranjangTerpilihSplit['GROUP'],
        dataKeranjangTerpilihSplit['BARANG'],
        dataKeranjangTerpilihSplit['QTY']
      ];
      // print(dataKeranjangTerpilihSplit);
      // print(dataKeranjangTerpilihSplit['NOURUT']);
      print('proses 1 jalan');
      Future<bool> proses1 =
          hapusJldtCt.hapusBarangOnce(dataSelected, 'proses_split_bill');
      var hasilProses1 = await proses1;
      print('hasil proses 1 $hasilProses1');
      if (hasilProses1 == true) {
        print('proses 2 jalan');
        Future<bool> proses2 =
            simpanFakturCt.simpanFakturSebagaiArsip('proses_split_bill');
        var hasilProses2 = await proses2;
        print('hasil proses 2 $hasilProses2');
        if (hasilProses2 == true) {
          print('proses 3 jalan');
          Future<bool> proses3 = buatFakturCt.getAkhirNomorFaktur();
          var hasilProses3 = await proses3;
          print('hasil proses 3 $hasilProses3');
          if (hasilProses3 == true) {
            print('proses 4 jalan');
            var dataProdukSelected = {
              'NOURUT': dataKeranjangTerpilihSplit['NOURUT'],
              'PK': dataKeranjangTerpilihSplit['PK'],
              'NOMOR': dataKeranjangTerpilihSplit['NOMOR'],
              'GUDANG': dataKeranjangTerpilihSplit['GUDANG'],
              'GROUP': dataKeranjangTerpilihSplit['GROUP'],
              'KODE': dataKeranjangTerpilihSplit['BARANG'],
              'QTY': dataKeranjangTerpilihSplit['QTY'],
              'SAT': dataKeranjangTerpilihSplit['SAT'],
            };
            Future<bool> proses4 = masukKeranjangCt
                .aksiMasukKeranjangLocal([dataProdukSelected], [], 0);
            var hasilProses4 = await proses4;
            print('hasil proses 4 $hasilProses4');
            if (hasilProses4 == true) {
              Get.back();
              Get.back();
              Get.back();
              // dashboardCt.startLoad('');
            }
          }
        }
      }
    }
  }

  void refreshAll() {
    dataKeranjangScreenSplitBill.refresh();
    jumlahBarangKeranjangAsli.refresh();
  }
}
