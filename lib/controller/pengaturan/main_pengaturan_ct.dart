import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/model/pelanggan.dart';
import 'package:siscom_pos/model/sales.dart';
import 'package:siscom_pos/utils/toast.dart';

class mainPengaturanController extends GetxController {
  var sidebarCt = Get.put(SidebarController());

  var passwordLama = TextEditingController().obs;
  var passwordBaru = TextEditingController().obs;
  var konfirmasiPasswordBaru = TextEditingController().obs;

  var dataAllSales = <SalesModel>[].obs;
  var dataAllPelanggan = <PelangganModel>[].obs;

  var showpasswordLama = false.obs;
  var showpasswordBaru = false.obs;
  var showKonfirmasiPasswordBaru = false.obs;

  var kodeSalesDefault = "".obs;
  var namaSalesDefault = "".obs;

  var kodePelangganDefault = "".obs;
  var namaPelangganDefault = "".obs;

  void startLoad() {
    prosesGetSales();
  }

  void prosesGetSales() async {
    Future<List> prosesGetsales = GetDataController()
        .getDataSales(sidebarCt.cabangKodeSelectedSide.value);
    List hasilDataSales = await prosesGetsales;
    if (hasilDataSales.isNotEmpty) {
      var tampungDataSales = <SalesModel>[];
      for (var element in hasilDataSales) {
        tampungDataSales.add(SalesModel(
          kodeSales: element["KODE"],
          namaSales: element["NAMA"],
          alamatSales: element["ALAMAT1"],
          nomorSales: element["TELP"],
          gudangSales: element["GUDANG"],
          limitSales: element["LIMIT"],
          isSelected: false,
        ));
      }
      var dataFirst = tampungDataSales.first;
      dataAllSales.value = tampungDataSales;
      dataAllSales.refresh();
      prosesGetPelanggan(dataFirst.kodeSales);
    }
  }

  void prosesGetPelanggan(kodeSales) async {
    Future<List> prosesGetpelanggan =
        GetDataController().getDataPelanggan(kodeSales);
    List hasilDatapelanggan = await prosesGetpelanggan;

    if (hasilDatapelanggan.isNotEmpty) {
      var tampungDataPelanggan = <PelangganModel>[];
      for (var element in hasilDatapelanggan) {
        tampungDataPelanggan.add(PelangganModel(
          kodePelanggan: element["KODE"],
          namaPelanggan: element["NAMA"],
          wilayahPelanggan: element["WILAYAH"],
          kodeSalesPelanggan: element["SALESM"],
          isSelected: false,
        ));
      }
      dataAllPelanggan.value = tampungDataPelanggan;
      dataAllPelanggan.refresh();
      prosesValidasiData();
    }
  }

  void prosesValidasiData() {
    var dataWhereCabang = sidebarCt.listCabangMaster.firstWhere(
        (element) => element["KODE"] == sidebarCt.cabangKodeSelectedSide.value);
    // check data pelanggan
    var dataWherePelanggan = dataAllPelanggan.firstWhere(
        (element) => element.kodePelanggan == dataWhereCabang["CUSTOM"]);
    kodePelangganDefault.value = dataWherePelanggan.kodePelanggan!;
    namaPelangganDefault.value = dataWherePelanggan.namaPelanggan!;
    kodePelangganDefault.refresh();
    namaPelangganDefault.refresh();
    // check data sales
    var dataWhereSales = dataAllSales.firstWhere((element) =>
        element.kodeSales == dataWherePelanggan.kodeSalesPelanggan);
    kodeSalesDefault.value = dataWhereSales.kodeSales!;
    namaSalesDefault.value = dataWhereSales.namaSales!;
    kodeSalesDefault.refresh();
    namaSalesDefault.refresh();
  }

  void validasiSimpanNewPassword() {
    ButtonSheetController().validasiButtonSheet("Simpan Perubahan",
        Text("Yakin simpan perubahan password"), "", "Simpan", () {
      if (passwordLama.value.text != sidebarCt.passwordPengguna.value) {
        UtilsAlert.showToast("Password lama salah !");
        Get.back();
      } else {
        if (passwordBaru.value.text != konfirmasiPasswordBaru.value.text) {
          UtilsAlert.showToast(
              "Password Baru dan Konfirmasi Password tidak sama  !");
          Get.back();
        } else {
          Get.back();
        }
      }
    });
  }
}
