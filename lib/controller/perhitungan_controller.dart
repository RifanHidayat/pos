import 'package:get/get.dart';

class PerhitunganController extends GetxController {
  Future<dynamic> kurangQty(double qtyNow, double hargaJual) {
    var hasilAkhir;

    if (qtyNow <= 0) {
      hasilAkhir = false;
    } else {
      double hitungQty = qtyNow - 1;
      double hitungJml = hargaJual * hitungQty;
      hasilAkhir = [hitungQty, hitungJml];
    }

    return Future.value(hasilAkhir);
  }

  Future<dynamic> inputQty(double qtyInput, double hargaJual) {
    var hasilAkhir;

    var hitung = hargaJual * qtyInput;
    String flt1 = hitung.toStringAsFixed(2);
    hasilAkhir = double.parse(flt1);

    return Future.value(hasilAkhir);
  }
}
