import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
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
      var dataKeranjangTerpilihSplit = dashboardCt.listKeranjangArsip.value
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
      Future<bool> proses2SplitBill = aksiProses2SplitBill();
      var hasilProses2 = await proses2SplitBill;
      // hapusJldtCt.hapusBarangOnce(dataSelected, 'proses_split_bill');
      // simpanFakturCt.simpanFakturSebagaiArsip('proses_split_bill');
      // dashboardCt.getAkhirNomorFaktur();
      // masukKeranjangCt
      //     .aksiMasukKeranjangLocal([dataKeranjangTerpilihSplit], []);
      // Get.back();
      // Get.back();
      // Get.back();
      // dashboardCt.startLoad('');
    }
  }

  Future<bool> aksiProses2SplitBill() {
    bool hasilAkhir = false;

    return Future.value(hasilAkhir);
  }

  void refreshAll() {
    dataKeranjangScreenSplitBill.refresh();
    jumlahBarangKeranjangAsli.refresh();
  }
}
