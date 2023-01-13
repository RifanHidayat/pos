import 'package:get/get.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class PerhitunganCt extends GetxController {
  Future<List> kurangQty(String qtyNow, String hargaJual) {
    var hasilAkhir;

    double filterQty = double.parse(qtyNow);

    if (filterQty < 0) {
      hasilAkhir = false;
    } else {
      double hitungQty = filterQty - 1;
      double filterHargaJual = Utility.convertStringRpToDouble(hargaJual);
      double hitungJml = filterHargaJual * hitungQty;
      hasilAkhir = [hitungQty, hitungJml];
    }

    return Future.value(hasilAkhir);
  }

  Future<dynamic> inputQty(String qtyInput, String hargaJual) {
    var hasilAkhir;

    var vld1 = "$qtyInput".replaceAll(".", ".");
    var vld2 = vld1.replaceAll(",", ".");
    double vld3 = double.parse(vld2);
    var vld4 = vld3 == 0.0 || vld3 < 0.0 ? 1.0 : vld3;

    if (vld4 < 0) {
      hasilAkhir = false;
    } else {
      double filterHargaJual = Utility.convertStringRpToDouble(hargaJual);

      var hitung = filterHargaJual * vld4;

      hasilAkhir = [vld4, hitung];
    }

    return Future.value(hasilAkhir);
  }

  Future<dynamic> tambahQty(String qtyNow, String hargaJual) {
    var hasilAkhir;

    double filterQty = double.parse(qtyNow);

    if (filterQty < 0) {
      hasilAkhir = false;
    } else {
      double hitungQty = filterQty + 1;
      double filterHargaJual = Utility.convertStringRpToDouble(hargaJual);
      double hitungJml = filterHargaJual * hitungQty;
      hasilAkhir = [hitungQty, hitungJml];
    }

    return Future.value(hasilAkhir);
  }

  Future<dynamic> hitungPersenDiskon(
      String persenDiskon, String hargaJual, String jumlahPesan) {
    var hasilAkhir;

    var vld1 = persenDiskon.replaceAll(".", ".");
    var vld2 = vld1.replaceAll(",", ".");
    double vld3 = double.parse(vld2);

    var flt1 = hargaJual.replaceAll(".", "");

    double hitung = Utility.nominalDiskonHeader(flt1, "$vld3");

    double hitungTotalHarga = double.parse(flt1) * double.parse(jumlahPesan);

    var hitungFinal = hitungTotalHarga - hitung;

    if (hitungFinal < 0) {
      UtilsAlert.showToast("Gagal tambah diskon");
      hasilAkhir = [false];
    } else {
      String nominalDiskonBarang =
          Utility.rupiahFormat("${hitung.toInt()}", "");

      var flt1 = hitung * double.parse(jumlahPesan);
      var totalHargaUpdate = hitungTotalHarga - flt1;
      hasilAkhir = [nominalDiskonBarang, totalHargaUpdate];
    }

    return Future.value(hasilAkhir);
  }

  Future<dynamic> hitungNominalDiskon(
      String nominalDiskon, String hargaJual, String jumlahPesan) {
    var hasilFinal;

    var flt1 = hargaJual.replaceAll(".", "");
    double hitungTotalHarga = double.parse(flt1) * double.parse(jumlahPesan);

    double inputNominal = Utility.convertStringRpToDouble(nominalDiskon);

    var hitung = (inputNominal / double.parse("$flt1")) * 100;

    var hitungFinal = inputNominal * double.parse(jumlahPesan);

    String hasilPersenDiskon = hitung.toStringAsFixed(2);
    double hasilTotalHargaUpdate = hitungTotalHarga - hitungFinal;

    if (hasilTotalHargaUpdate <= 0) {
      UtilsAlert.showToast("Gagal input nominal diskon");
      hasilFinal = [false];
    } else {
      hasilFinal = [hasilPersenDiskon, hasilTotalHargaUpdate];
    }

    return Future.value(hasilFinal);
  }

  Future<double> hitungNominalDiskonHeader(
      String persenDiskon, String subtotal) {
    var vld1 = persenDiskon.replaceAll(".", ".");
    var vld2 = vld1.replaceAll(",", ".");
    double vld3 = double.parse(vld2);
    double hitungNominal = Utility.nominalDiskonHeader(subtotal, "$vld3");

    return Future.value(hitungNominal);
  }

  Future<String> hitungPersenDiskonHeader(
      String nominalPersen, String subtotal) {
    var inputNominal = nominalPersen.replaceAll(".", "");
    var hitung = (double.parse(inputNominal) / double.parse(subtotal)) * 100;

    String hitungNominal = hitung.toStringAsFixed(2);

    return Future.value(hitungNominal);
  }

  Future<double> hitungNominalPPNHeader(
      double persenPPN, double subtotal, double nominalDiskon) {
    double hargaSetelahDiskon = subtotal - nominalDiskon;
    double hitung1 =
        Utility.nominalPPNHeader("$hargaSetelahDiskon", "$persenPPN");
    return Future.value(hitung1);
  }

  Future<String> hitungPersenPPNHeader(
      double nominalPPN, double subtotal, double nominalDiskon) {
    double hargaSetelahDiskon = subtotal - nominalDiskon;
    var hitung = (nominalPPN / hargaSetelahDiskon) * 100;
    String hasilPersenPPN = hitung.toStringAsFixed(2);
    return Future.value(hasilPersenPPN);
  }

  Future<double> hitungNettoOrderPenjualan(
      double subtotal, double nominalDiskon, double ppn, double ongkos) {
    double hitung1 = subtotal - nominalDiskon;
    double hitung2 = hitung1 + ppn + ongkos;
    return Future.value(hitung2);
  }

  Future<double> jikaAdaDiskon(
    double totalPesan,
    String nominalDiskon,
    double qtyNow,
  ) {
    double filterNominalDiskon = Utility.convertStringRpToDouble(nominalDiskon);
    double hitung = filterNominalDiskon * qtyNow;
    double hitungFinal = totalPesan - hitung;

    return Future.value(hitungFinal);
  }
}
