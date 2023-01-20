import 'package:get/get.dart';
import 'package:siscom_pos/controller/pos/simpan_pembayaran_split_ct.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';

class SelesaiPembayaranController extends GetxController {
  var simpanPembayaranCt = Get.put(SimpanPembayaranSplit());
  var splitJumlahBayar = Get.put(SplitJumlahBayarController());

  var pembayaranStatus = false.obs;
  var totalSplitPembayaran = 0.0.obs;

  void startLoad(dataPembayaran) {
    print(dataPembayaran);
    if (dataPembayaran.isEmpty) {
      pembayaranStatus.value = false;
    } else {
      pembayaranStatus.value = true;
    }
    simpanPembayaranCt.informasiSelesaiPembayaran.value = dataPembayaran;
    simpanPembayaranCt.informasiSelesaiPembayaran.refresh();
    chekingListSplit();
  }

  void chekingListSplit() {
    if (splitJumlahBayar.listPembayaranSplit.isNotEmpty) {
      double tampungTotal = 0.0;
      splitJumlahBayar.listPembayaranSplit.forEach((element) {
        tampungTotal += element['total_bayar'];
      });
      totalSplitPembayaran.value = tampungTotal;
      totalSplitPembayaran.refresh();
    }
  }
}
