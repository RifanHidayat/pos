import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  // COLOR
  static Color baseColor1 = Color(0xff11151e);
  static Color baseColor2 = Color(0xffffffff);
  static Color fielddisable = Color(0xffE9EDF5);

  static Color primaryDefault = Color(0xff001767);
  static Color primaryDark600 = Color(0xff001158);
  static Color primaryDark700 = Color(0xff000d4a);
  static Color primaryDark800 = Color(0xff00093b);
  static Color primaryDark900 = Color(0xff000631);

  static Color primaryLight50 = Color(0xffe1e9fa);
  static Color primaryLight100 = Color(0xffc5d5f7);
  static Color primaryLight200 = Color(0xff8fabef);
  static Color primaryLight300 = Color(0xff5375d1);
  static Color primaryLight400 = Color(0xff2847a3);

  static Color infoLight50 = Color(0xffe9f5fe);
  static Color infoLight100 = Color(0xffd5edfe);
  static Color infoLight200 = Color(0xffacd9fd);
  static Color infoLight300 = Color(0xff81bff9);
  static Color infoLight400 = Color(0xff61a6f4);

  static Color infoDefault = Color(0xff2f80ed);
  static Color infoDark600 = Color(0xff2263cb);
  static Color infoDark700 = Color(0xff1749aa);
  static Color infoDark800 = Color(0xff0e3389);
  static Color infoDark900 = Color(0xff092371);

  static Color nonAktif = Color(0xff868FA0);
  static Color greyLight300 = Color(0xffBCC2CE);
  static Color greyLight100 = Color(0xffE9EDF5);
  static Color greyLight50 = Color(0xffF8FAFF);
  static Color grey100 = Color(0xffE9EDF5);
  static Color grey600 = Color(0xff687182);
  static Color grey300 = Colors.grey.shade300;
  static Color grey500 = Colors.grey.shade500;
  static Color grey900 = Color(0xff333B4A);
  static Color greyDark = Color(0xff333B4A);

  static Color errorLight = Color(0xffFFE7D8);
  static Color succesLight = Color(0xffE6FCE6);
  static Color borderContainer = Color.fromARGB(255, 211, 205, 205);
  static Color shadowColor =
      Color.fromARGB(255, 190, 190, 190).withOpacity(0.3);

  // SIZE
  static double verySmall = 8.0;
  static double small = 10.0;
  static double normal = 12.0;
  static double semiMedium = 14.0;
  static double medium = 16.0;
  static double large = 20.0;
  static double extraLarge = 24.0;

  // BORDER RADIUS
  static BorderRadius borderStyle1 = BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
      bottomLeft: Radius.circular(6),
      bottomRight: Radius.circular(6));

  static BorderRadius borderStyle2 = BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16));

  static BorderRadius borderStyle3 = BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24));

  static BorderRadius borderStyle4 = BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8));

  static BorderRadius borderStyle5 = BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10));

  // TEXT CUSTOM

  static TextStyle judulList = TextStyle(
      fontWeight: FontWeight.bold, fontSize: medium, color: primaryDefault);

  static TextStyle isiList = TextStyle(fontSize: normal, color: nonAktif);

  // CONVERT DATE

  static String convertDate(String date) {
    DateTime convert = DateTime.parse(date);
    var hari = DateFormat('EEEE');
    var tanggal = DateFormat('dd-MM-yyyy');
    var convertHari = hari.format(convert);
    var hasilConvertHari = hariIndo(convertHari);
    var valid2 = tanggal.format(convert);
    var validFinal = "$hasilConvertHari, $valid2";
    return validFinal;
  }

  static String convertDate1(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate2(String date) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate3(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('MMMM yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate4(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate5(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd MMMM yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertNoFaktur(String nofaktur) {
    var getPolaType = nofaktur.substring(0, 2);
    var getTahun = nofaktur.substring(2, 6);
    var getBulan = nofaktur.substring(6, 8);
    var getNomor = nofaktur.substring(8, 12);
    return "$getPolaType-$getTahun/$getBulan-$getNomor";
  }

  static String convertNoFakturBuatOrderPenjualan(String nofaktur) {
    var getPolaType = nofaktur.substring(0, 2);
    var getTahun = nofaktur.substring(2, 6);
    var getBulan = nofaktur.substring(6, 8);
    return "$getPolaType-$getTahun/$getBulan-xxxx";
  }

  static double hitungTotalPembelianBarang(
      String hargaBarang, String qtyBeli, String discd) {
    var hitung = double.parse(discd) * double.parse(qtyBeli);
    var hitung2 = double.parse(hargaBarang) * double.parse(qtyBeli);
    var hitungFinal = hitung2 - hitung;
    return hitungFinal;
  }

  static double persenDiskonHeader(String subtotal, String nominalDiskon) {
    var hitung = (double.parse(nominalDiskon) / double.parse(subtotal)) * 100;
    return hitung;
  }

  static double nominalDiskonHeader(String subtotal, String persenDiskon) {
    var hitung = (double.parse(subtotal) * double.parse(persenDiskon)) / 100;
    return hitung;
  }

  static double nominalPPNHeader(String subtotal, String ppnHeader) {
    var hitung = (double.parse(subtotal) * double.parse(ppnHeader)) / 100;
    return hitung;
  }

  static double nominalServiceCharge(String subtotal, String serviceCharge) {
    var hitung = (double.parse(subtotal) * double.parse(serviceCharge)) / 100;
    return hitung;
  }

  static double nominalPPNHeaderView(
      String subtotal, String diskonHeader, String ppnHeader) {
    var hitung = (double.parse(subtotal) * double.parse(diskonHeader)) / 100;
    var hitung1 = double.parse(subtotal) - hitung;
    var hitung2 = (hitung1 * double.parse(ppnHeader)) / 100;
    return hitung2;
  }

  static double nominalServiceChargeView(
      String subtotal, String diskonHeader, String serviceCharge) {
    var hitung = (double.parse(subtotal) * double.parse(diskonHeader)) / 100;
    var hitung1 = double.parse(subtotal) - hitung;
    var hitung2 = (hitung1 * double.parse(serviceCharge)) / 100;
    return hitung2;
  }

  static double hitungDetailTotalPos(
      String subtotal, String diskon, String ppn, String serviceCharge) {
    var fltr1 = (double.parse(subtotal) * double.parse(diskon)) / 100;
    var fltr2 = double.parse(subtotal) - fltr1;
    var nominalDiskon = fltr1;

    var fltr3 = (fltr2 * double.parse(ppn)) / 100;
    var nominalPpn = fltr3;

    var fltr5 = (fltr2 * double.parse(serviceCharge)) / 100;
    var nominalService = fltr5;

    var nominalFinal =
        double.parse(subtotal) - nominalDiskon + nominalPpn + nominalService;

    return nominalFinal;
  }

  static int validasiValueint(String value) {
    var vld1 = value.replaceAll(",", "");
    var vld2 = vld1.replaceAll(".", "");
    var val3 = int.parse(vld2);
    return val3;
  }

  static double validasiValueDouble(String value) {
    var vld1 = value.replaceAll(",", ".");
    var vld2 = vld1.replaceAll(".", ".");
    var val3 = double.parse(vld2);
    return val3;
  }

  static double convertStringRpToDouble(String value) {
    var filter1 = value.replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var filter4 = filter3.replaceAll(",", ".");
    var valueFinal = double.parse(filter4);
    return valueFinal;
  }

  static int pengurangan(String value1, String value2) {
    var filter1 = int.parse(value1);
    var filter2 = int.parse(value2);
    var pengurangan = filter1 - filter2;
    return pengurangan;
  }

  static String rupiahFormat(String nominal, String type) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 2,
    );
    NumberFormat currencyFormatterRp = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    String hasilFinal = "";
    if (type == "with_rp") {
      hasilFinal = currencyFormatterRp.format(double.parse(nominal));
    } else {
      hasilFinal = currencyFormatter.format(double.parse(nominal));
    }
    return hasilFinal;
  }

  // SETTING

  static String hariIndo(String hari) {
    if (hari == "Monday") {
      hari = "Senin";
    } else if (hari == "Tuesday") {
      hari = "Selasa";
    } else if (hari == "Wednesday") {
      hari = "Rabu";
    } else if (hari == "Thursday") {
      hari = "Kamis";
    } else if (hari == "Friday") {
      hari = "Jumat";
    } else if (hari == "Saturday") {
      hari = "Sabtu";
    } else if (hari == "Sunday") {
      hari = "Minggu";
    } else {
      hari = hari;
    }
    return hari;
  }
}
