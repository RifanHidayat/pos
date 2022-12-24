import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class DashbardPenjualanController extends GetxController {
  var sidebarCt = Get.put(SidebarController());
  var getDataCt = Get.put(GetDataController());

  var cari = TextEditingController().obs;
  var refrensiBuatOrderPenjualan = TextEditingController().obs;
  var jatuhTempoBuatOrderPenjualan = TextEditingController().obs;
  var keteranganSO1 = TextEditingController().obs;
  var keteranganSO2 = TextEditingController().obs;
  var keteranganSO3 = TextEditingController().obs;
  var keteranganSO4 = TextEditingController().obs;
  var passwordBukaKunci = TextEditingController().obs;

  var selectedIdSales = "".obs;
  var selectedNameSales = "".obs;
  var selectedIdPelanggan = "".obs;
  var selectedNamePelanggan = "".obs;
  var wilayahCustomerSelected = "".obs;
  var periode = "".obs;
  var typeFocus = "".obs;
  var nomorSoSelected = "".obs;

  var checkIncludePPN = false.obs;
  var screenBuatSoKeterangan = false.obs;
  var showpassword = false.obs;

  var jumlahArsipOrderPenjualan = 0.obs;

  var menuShowonTop = [].obs;
  var salesList = [].obs;
  var pelangganList = [].obs;
  var dataAllSohd = [].obs;
  var dataSohd = [].obs;

  var dateSelectedBuatOrderPenjualan = DateTime.now().obs;
  var tanggalAkumulasiJatuhTempo = DateTime.now().obs;

  var screenAktif = 1.obs;

  List menuDashboardPenjualan = [
    {'id_menu': 1, 'nama_menu': "Order Penjualan", 'status': true},
    {'id_menu': 2, 'nama_menu': "Nota Pengiriman Barang", 'status': false},
    {'id_menu': 3, 'nama_menu': "Faktur Penjualan", 'status': false},
  ];

  void loadData() {
    getDataMenuPenjualan();
    checkArsipOrderPenjualan();
    getDataSales();
    getDataAllSOHD();
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  void getDataMenuPenjualan() {
    for (var element in menuDashboardPenjualan) {
      menuShowonTop.value.add(element);
    }
    menuShowonTop.refresh();
  }

  void checkGestureDetector() {
    if (typeFocus.value == "jatuh_tempo") {
      gantiJatuhTempoBuatOrderPenjualan(
          jatuhTempoBuatOrderPenjualan.value.text);
    }
  }

  void checkArsipOrderPenjualan() {
    if (AppData.arsipOrderPenjualan != "") {
      List tampung = AppData.arsipOrderPenjualan.split("|");
      jumlahArsipOrderPenjualan.value = tampung.length;
      jumlahArsipOrderPenjualan.refresh();
    } else {
      jumlahArsipOrderPenjualan.value = 0;
      jumlahArsipOrderPenjualan.refresh();
    }
  }

  void timeNow() {
    var dt = DateTime.now();
    var year = "${DateFormat('yyyy').format(dt)}";
    var bulan = "${DateFormat('MM').format(dt)}";
    periode.value = "SI$year$bulan";
  }

  void gantiTanggalBuatOrderPenjualan(date) {
    DateTime dateStart = DateTime.now(); //YOUR DATE GOES HERE
    bool isValidDate = dateStart.isBefore(date);
    if (isValidDate) {
      UtilsAlert.showToast("Tanggal tidak boleh melebihi tanggal hari ini");
    } else {
      dateSelectedBuatOrderPenjualan.value = date;
    }
  }

  void gantiJatuhTempoBuatOrderPenjualan(value) {
    if (value == "") {
      print("Kosong");
      tanggalAkumulasiJatuhTempo.value = DateTime.now();
      tanggalAkumulasiJatuhTempo.refresh();
    } else {
      if (int.parse(value) <= 0) {
        tanggalAkumulasiJatuhTempo.value = DateTime.now();
        tanggalAkumulasiJatuhTempo.refresh();
      } else {
        DateTime dt = DateTime.parse("${DateTime.now()}");
        DateTime tanggalAkumulasi = dt.add(Duration(days: int.parse(value)));
        tanggalAkumulasiJatuhTempo.value = tanggalAkumulasi;
        tanggalAkumulasiJatuhTempo.refresh();
      }
    }
  }

  void getDataSales() async {
    Future<List> prosesGetSales =
        getDataCt.getDataSales(sidebarCt.cabangKodeSelectedSide.value);
    List data = await prosesGetSales;
    if (data.isNotEmpty) {
      data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
      salesList.value = data;
      salesList.refresh();
      var getFirst = data.first;
      selectedIdSales.value = getFirst['KODE'];
      selectedNameSales.value = getFirst['NAMA'];
      selectedIdSales.refresh();
      selectedNameSales.refresh();
      getDataPelanggan();
    }
  }

  void getDataPelanggan() async {
    Future<List> prosesGetPelanggan =
        getDataCt.getDataSales(sidebarCt.cabangKodeSelectedSide.value);
    List data = await prosesGetPelanggan;
    if (data.isNotEmpty) {
      data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
      pelangganList.value = data;
      pelangganList.refresh();
      var getFirst = data.first;
      selectedIdPelanggan.value = getFirst['KODE'];
      selectedNamePelanggan.value = getFirst['NAMA'];
      selectedIdPelanggan.refresh();
      selectedNamePelanggan.refresh();
    }
  }

  void getDataAllSOHD() async {
    Future<List> prosesDataAllSOHD = getDataCt.getDataAllSOHD();
    List data = await prosesDataAllSOHD;
    if (data.isNotEmpty) {
      dataAllSohd.value = data;
      dataAllSohd.refresh();
    }
  }

  void getDataSOHD() async {
    Future<List> prosesDataOnceSOHD =
        getDataCt.getDataSOHD(nomorSoSelected.value);
    List data = await prosesDataOnceSOHD;
    if (data.isNotEmpty) {
      dataSohd.value = data;
      dataSohd.refresh();
    }
  }

  void lanjutkanSoPenjualan(dataSelected) async {
    if (dataSelected["IP"] == "") {
      prosesLanjugkanSoPenjualan(dataSelected);
    } else {
      var emailUserLogin = AppData.informasiLoginUser.split("-");
      var statusSysUser = AppData.sysuserInformasi.split("-");
      var getUsLevel = statusSysUser[1];
      Future<List> settingOtoritas = getDataCt.getSpesifikData(
          "SYSDATA", "KODE", "019", "get_spesifik_data_master");
      List hasilSetting = await settingOtoritas;
      String fltr1 = hasilSetting[0]["NAMA"];
      var kodeOtoritasBukaKunci = fltr1.substring(13, 14);
      if (int.parse(getUsLevel) <= int.parse(kodeOtoritasBukaKunci)) {
        passwordBukaKunci.value.text = "";
        ButtonSheetController().validasiButtonSheet(
            "Buka kunci", contentBukaKunciForm(), "order_penjualan", () {
          validasiBukaKunci(emailUserLogin, dataSelected);
        });
      } else {
        UtilsAlert.showToast("Maaf anda tidak memiliki akses");
      }
    }
  }

  void prosesLanjugkanSoPenjualan(dataSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");
    dataSohd.value = [dataSelected];
    dataSohd.refresh();
    Future<List> getSalesSpesifik = getDataCt.getSpesifikData(
        "SALESM", "KODE", dataSelected["SALESM"], "get_spesifik_data_master");
    List dataSales = await getSalesSpesifik;
    Future<List> getPelangganSpesifik = getDataCt.getSpesifikData(
        "CUSTOM", "KODE", dataSelected["CUSTOM"], "get_spesifik_data_master");
    List dataPelanggan = await getPelangganSpesifik;

    nomorSoSelected.value = dataSelected["NOMOR"];
    nomorSoSelected.value = dataSelected["NOMOR"];
    selectedIdSales.value = dataSales[0]["KODE"];
    selectedNameSales.value = dataSales[0]["NAMA"];
    selectedIdPelanggan.value = dataSelected["CUSTOM"];
    selectedNamePelanggan.value = dataPelanggan[0]["NAMA"];
    wilayahCustomerSelected.value = dataSelected["WILAYAH"];

    nomorSoSelected.refresh();
    selectedIdSales.refresh();
    selectedNameSales.refresh();
    selectedIdPelanggan.refresh();
    selectedNamePelanggan.refresh();
    wilayahCustomerSelected.refresh();

    Future<bool> prosesPilihCabang =
        sidebarCt.pilihCabangSelected(dataSelected["CB"]);
    bool hasilPilihCabang = await prosesPilihCabang;

    Future<bool> prosesDeviceIp =
        getDataCt.closeSODH(sidebarCt.ipdevice.value, nomorSoSelected.value);
    bool hasilProsesDevice = await prosesDeviceIp;
    print("ip device $hasilProsesDevice");

    if (dataSales.isEmpty) {
      Get.back();
      UtilsAlert.showToast("Data sales tidak valid");
    } else if (dataPelanggan.isEmpty) {
      Get.back();
      UtilsAlert.showToast("Data pelanggan tidak valid");
    } else if (hasilPilihCabang == false) {
      Get.back();
      UtilsAlert.showToast("Data cabang tidak valid");
    } else {
      Get.back();
      Get.to(ItemOrderPenjualan(dataForm: true),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeftWithFade);
    }
  }

  void validasiBukaKunci(emailUserLogin, dataSelected) async {
    Future<bool> prosesValidasi =
        getDataCt.validasiUser(emailUserLogin[0], passwordBukaKunci.value.text);
    bool hasilValidasi = await prosesValidasi;
    if (hasilValidasi) {
      Get.back();
      prosesLanjugkanSoPenjualan(dataSelected);
    } else {
      Get.back();
      UtilsAlert.showToast("Password yang anda masukkan salah");
    }
  }

  Widget contentBukaKunciForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Utility.small,
        ),
        CardCustomForm(
          colorBg: Utility.baseColor2,
          tinggiCard: 50.0,
          radiusBorder: Utility.borderStyle1,
          widgetCardForm: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => TextField(
                cursorColor: Utility.primaryDefault,
                obscureText: !this.showpassword.value,
                controller: passwordBukaKunci.value,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showpassword.value ? Iconsax.eye : Iconsax.eye_slash,
                        color: this.showpassword.value
                            ? Utility.primaryDefault
                            : Utility.nonAktif,
                      ),
                      onPressed: () {
                        this.showpassword.value = !this.showpassword.value;
                      },
                    )),
                style:
                    TextStyle(fontSize: 14.0, height: 2.0, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
