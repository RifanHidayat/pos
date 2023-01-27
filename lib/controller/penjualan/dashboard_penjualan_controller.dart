import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/cetak_penjualan.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/hapus_dodt.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/item_order_penjualan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/buat_penjualan.dart';
import 'package:siscom_pos/screen/penjualan/detail_nota_pengiriman_barang.dart';
import 'package:siscom_pos/screen/penjualan/faktur_penjualan_si.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

class DashbardPenjualanController extends GetxController {
  var sidebarCt = Get.put(SidebarController());
  var getDataCt = Get.put(GetDataController());

  var cari = TextEditingController().obs;
  var refrensiBuatOrderPenjualan = TextEditingController().obs;
  var jatuhTempoBuatOrderPenjualan = TextEditingController(text: "0").obs;
  var keteranganSO1 = TextEditingController().obs;
  var keteranganSO2 = TextEditingController().obs;
  var keteranganSO3 = TextEditingController().obs;
  var keteranganSO4 = TextEditingController().obs;
  var passwordBukaKunci = TextEditingController().obs;
  var noseri1 = TextEditingController(text: "").obs;
  var noseri2 = TextEditingController(text: "").obs;

  var selectedIdSales = "".obs;
  var selectedNameSales = "".obs;
  var selectedIdPelanggan = "".obs;
  var selectedNamePelanggan = "".obs;
  var wilayahCustomerSelected = "".obs;
  var periode = "".obs;
  var typeFocus = "".obs;
  var includePPN = "".obs;
  // ORDER PENJUALAN
  var nomorSoSelected = "".obs;
  var nomoCbSelected = "".obs;
  // NOTA PENGIRIMAN BARANG
  var nomorDoSelected = "".obs;
  var nomoDoCbSelected = "".obs;
  // FAKTUR PENJUALAN
  var nomorFakturPenjualanSelected = "".obs;
  var nomoFakturPenjualanCbSelected = "".obs;
  var pilihDataSelected = "Faktur Penjualan".obs;

  var checkIncludePPN = false.obs;
  var screenBuatSoKeterangan = false.obs;
  var showpassword = false.obs;

  var screenStatusOrderPenjualan = true.obs;
  var screenStatusNotaPengiriman = true.obs;
  var screenStatusFakturPenjualan = true.obs;

  var jumlahArsipOrderPenjualan = 0.obs;
  var statusBuatPenjualan = 0.obs;

  var menuShowonTop = [].obs;
  var salesList = [].obs;
  var pelangganList = [].obs;
  // ORDER PENJUALAN
  var dataAllSohd = [].obs;
  var dataSohd = [].obs;
  // NOTA PENGIRIMAN BARANG
  var dataAllDohd = [].obs;
  var dohdSelected = [].obs;
  // NOTA PENGIRIMAN BARANG
  var dataFakturPenjualan = [].obs;
  var fakturPenjualanSelected = [].obs;

  var dateSelectedBuatOrderPenjualan = DateTime.now().obs;
  var tanggalAkumulasiJatuhTempo = DateTime.now().obs;

  var screenAktif = 1.obs;

  var pilihDataBuatFakturPenjualan = [
    'Faktur Penjualan',
    'Nota Pengiriman Barang'
  ];

  List menuDashboardPenjualan = [
    {'id_menu': 1, 'nama_menu': "Order Penjualan", 'status': true},
    {'id_menu': 2, 'nama_menu': "Nota Pengiriman Barang", 'status': false},
    {'id_menu': 3, 'nama_menu': "Faktur Penjualan", 'status': false},
  ];

  void loadData() {
    getDataMenuPenjualan();
    checkArsipOrderPenjualan();
    getDataSales("load_first");
    getDataAllSOHD();
    checkSysdata();
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  void getDataMenuPenjualan() {
    List tampungMenu = [];
    for (var element in menuDashboardPenjualan) {
      tampungMenu.add(element);
    }
    menuShowonTop.value = tampungMenu;
    menuShowonTop.refresh();
  }

  void checkGestureDetector() {
    if (typeFocus.value == "jatuh_tempo") {
      gantiJatuhTempoBuatOrderPenjualan(
          jatuhTempoBuatOrderPenjualan.value.text);
    }
  }

  void changeMenu(id) {
    if (id == 1) {
      getDataAllSOHD();
    } else if (id == 2) {
      getDataAllDOHD();
    } else if (id == 3) {
      getDataFakturPenjualan();
    }
    for (var element in menuShowonTop) {
      if (element['id_menu'] == id) {
        element['status'] = true;
      } else {
        element['status'] = false;
      }
    }
    screenAktif.value = id;
    screenAktif.refresh();
    menuShowonTop.refresh();
  }

  void changeStatusBuatPenjualan(value) {
    statusBuatPenjualan.value = value;
    statusBuatPenjualan.refresh();
  }

  void addPenjualan() {
    getDataSales("load_first");
    if (screenAktif.value == 1) {
      Get.to(
          BuatOrderPenjualan(
            dataBuatPenjualan: [1, "Order Penjualan"],
          ),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeftWithFade);
    } else if (screenAktif.value == 2) {
      Get.to(
          BuatOrderPenjualan(
            dataBuatPenjualan: [2, "Nota Pengiriman"],
          ),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeftWithFade);
    } else if (screenAktif.value == 3) {
      Get.to(
          BuatOrderPenjualan(
            dataBuatPenjualan: [3, "Faktur Penjualan"],
          ),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeftWithFade);
    }
  }

  void checkSysdata() {
    List dataSysdata = AppData.infosysdatacabang!;
    if (dataSysdata.isNotEmpty) {
      for (var element in dataSysdata) {
        if (element.kode == "037") {
          print('sysdata terpilih ${element.nama}');
          includePPN.value = element.nama;
          includePPN.refresh();
        }
      }
    }
  }

  void clearAllBuatOrderPenjualan() {
    refrensiBuatOrderPenjualan.value.text = "";
    jatuhTempoBuatOrderPenjualan.value.text = "";
    keteranganSO1.value.text = "";
    keteranganSO2.value.text = "";
    keteranganSO3.value.text = "";
    keteranganSO4.value.text = "";
    selectedIdSales.value = "";
    selectedNameSales.value = "";
    selectedIdPelanggan.value = "";
    selectedNamePelanggan.value = "";
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
    if (screenAktif.value == 1) {
      periode.value = "SO$year$bulan";
    } else if (screenAktif.value == 2) {
      periode.value = "DO$year$bulan";
    } else if (screenAktif.value == 3) {
      periode.value = "SI$year$bulan";
    }
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

  void getDataSales(type) async {
    print('proses list sales');
    Future<List> prosesGetSales =
        getDataCt.getDataSales(sidebarCt.cabangKodeSelectedSide.value);
    List data = await prosesGetSales;
    if (data.isNotEmpty) {
      data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
      salesList.value = data;
      salesList.refresh();
      selectedIdSales.refresh();
      selectedNameSales.refresh();
      getDataPelanggan(type);
    }
  }

  void getDataPelanggan(type) async {
    if (type == "load_first") {
      Future<List> checkDataCabang = GetDataController().getSpesifikData(
          "CABANG",
          "KODE",
          sidebarCt.cabangKodeSelectedSide.value,
          "get_spesifik_data_master");
      List hasilDataCabang = await checkDataCabang;

      if (hasilDataCabang.isNotEmpty) {
        Future<List> checkPelanggan = GetDataController().getSpesifikData(
            "CUSTOM",
            "KODE",
            hasilDataCabang[0]['CUSTOM'],
            "get_spesifik_data_master");
        List hasilDataPelanggan = await checkPelanggan;

        if (hasilDataPelanggan.isNotEmpty) {
          selectedNamePelanggan.value = hasilDataPelanggan[0]['NAMA'];
          selectedNamePelanggan.refresh();

          selectedIdPelanggan.value = hasilDataPelanggan[0]['KODE'];
          selectedIdPelanggan.refresh();

          wilayahCustomerSelected.value = hasilDataPelanggan[0]['WILAYAH'];
          wilayahCustomerSelected.refresh();

          var kodeSales = hasilDataPelanggan[0]['SALESM'];

          Future<List> checkSales = GetDataController().getSpesifikData(
              "SALESM", "KODE", kodeSales, "get_spesifik_data_master");
          List hasilDataSales = await checkSales;

          if (hasilDataSales.isNotEmpty) {
            selectedNameSales.value = hasilDataSales[0]['NAMA'];
            selectedNameSales.refresh();

            selectedIdSales.value = hasilDataSales[0]['KODE'];
            selectedIdSales.refresh();

            Future<List> listSalesSelected = GetDataController()
                .getSpesifikData("CUSTOM", "SALESM", selectedIdSales.value,
                    "get_spesifik_data_master");
            List tampungData = await listSalesSelected;
            tampungData.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));

            pelangganList.value = tampungData;
            pelangganList.refresh();
          }
        }
      }
    } else {
      pelangganList.clear();
      pelangganList.refresh();
      selectedIdPelanggan.value = "";
      selectedNamePelanggan.value = "";
      wilayahCustomerSelected.value = "";
      Future<List> prosesGetPelanggan =
          getDataCt.getDataPelanggan(selectedIdSales.value);
      List data = await prosesGetPelanggan;
      if (data.isNotEmpty) {
        data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
        pelangganList.value = data;
        pelangganList.refresh();
        var getFirst = data.first;
        selectedIdPelanggan.value = getFirst['KODE'];
        selectedNamePelanggan.value = getFirst['NAMA'];
        wilayahCustomerSelected.value = getFirst['WILAYAH'];
        selectedIdPelanggan.refresh();
        selectedNamePelanggan.refresh();
        wilayahCustomerSelected.refresh();
      }
    }
  }

  Future<bool> getDataAllSOHD() async {
    print("get all sohd running");
    dataAllSohd.clear();
    dataAllSohd.refresh();
    screenStatusOrderPenjualan.value = false;
    screenStatusOrderPenjualan.refresh();
    Future<List> prosesDataAllSOHD =
        getDataCt.getDataAllSOHD(sidebarCt.cabangKodeSelectedSide.value);
    List data = await prosesDataAllSOHD;
    bool hasil = false;
    if (data.isNotEmpty) {
      hasil = true;
      dataAllSohd.value = data;
      dataAllSohd.refresh();
      screenStatusOrderPenjualan.value = true;
      screenStatusOrderPenjualan.refresh();
    } else {
      hasil = false;
      screenStatusOrderPenjualan.value = true;
      screenStatusOrderPenjualan.refresh();
    }
    return Future.value(hasil);
  }

  Future<bool> getDataAllDOHD() async {
    print("get all dohd running");
    dataAllDohd.clear();
    dataAllDohd.refresh();
    screenStatusNotaPengiriman.value = false;
    screenStatusNotaPengiriman.refresh();
    Future<List> prosesDataAllDOHD =
        getDataCt.getDataAllDOHD(sidebarCt.cabangKodeSelectedSide.value);
    List data = await prosesDataAllDOHD;
    bool hasil = false;
    if (data.isNotEmpty) {
      hasil = true;
      dataAllDohd.value = data;
      dataAllDohd.refresh();
      screenStatusNotaPengiriman.value = true;
      screenStatusNotaPengiriman.refresh();
    } else {
      hasil = false;
      screenStatusNotaPengiriman.value = true;
      screenStatusNotaPengiriman.refresh();
    }
    return Future.value(hasil);
  }

  Future<bool> getDataFakturPenjualan() async {
    print("get all faktur penjualan running");
    dataFakturPenjualan.clear();
    dataFakturPenjualan.refresh();
    screenStatusFakturPenjualan.value = false;
    screenStatusFakturPenjualan.refresh();
    Future<List> prosesDataAllFakturPenjualan =
        getDataCt.getDataAllFakturPenjualan(
      sidebarCt.cabangKodeSelectedSide.value,
    );
    List data = await prosesDataAllFakturPenjualan;
    bool hasil = false;
    if (data.isNotEmpty) {
      hasil = true;
      dataFakturPenjualan.value = data;
      dataFakturPenjualan.refresh();
      screenStatusFakturPenjualan.value = true;
      screenStatusFakturPenjualan.refresh();
    } else {
      hasil = false;
      screenStatusFakturPenjualan.value = true;
      screenStatusFakturPenjualan.refresh();
    }
    return Future.value(hasil);
  }

  void loadSOHDSelected() {
    print('pilih sohd');
    dataSohd.value = dataAllSohd
        .where((ele) => ele['NOMOR'] == nomorSoSelected.value)
        .toList();
    dataSohd.refresh();
  }

  void loadDOHDSelected() {
    dohdSelected.value = dataAllDohd
        .where((ele) => ele['NOMOR'] == nomorDoSelected.value)
        .toList();
    dohdSelected.refresh();
  }

  void loadFakturPenjualanSelected() {
    fakturPenjualanSelected.value = dataFakturPenjualan
        .where((ele) => ele['NOMOR'] == nomorFakturPenjualanSelected.value)
        .toList();
    fakturPenjualanSelected.refresh();
  }

  void lanjutkanSoPenjualan(dataSelected, statusOutStand) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");
    print('status outs $statusOutStand');
    if (dataSelected["IP"] == "") {
      Get.back();
      String judul = screenAktif.value == 1
          ? "Order Penjualan"
          : screenAktif.value == 2
              ? "Nota Pengiriman Barang"
              : "";
      ButtonSheetController().validasiButtonSheet(
          judul,
          contentValidasiLanjutkan(dataSelected, statusOutStand),
          "validasi_lanjutkan_orderpenjualan",
          '',
          () {});
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
        Get.back();
        passwordBukaKunci.value.text = "";
        ButtonSheetController().validasiButtonSheet(
            "Buka kunci", contentBukaKunciForm(), "order_penjualan", 'Buka',
            () {
          validasiBukaKunci(emailUserLogin, dataSelected, statusOutStand);
        });
      } else {
        Get.back();
        UtilsAlert.showToast("Maaf anda tidak memiliki akses");
      }
    }
  }

  Widget contentValidasiLanjutkan(dataSelected, statusOutStand) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Button1(
                    textBtn: "Hapus",
                    colorBtn: Colors.red,
                    colorText: Colors.white,
                    onTap: () {
                      ButtonSheetController().validasiButtonSheet(
                          "Hapus Order Penjualan",
                          contenthapusOrderPenjualan(dataSelected),
                          "hapus_order_penjualan",
                          'Hapus', () async {
                        if (screenAktif.value == 1) {
                          if (statusOutStand == false) {
                            Future<bool> prosesHapusSOHD = GetDataController()
                                .hapusSOHD(dataSelected['NOMOR']);
                            bool hasilHapusSOHD = await prosesHapusSOHD;
                            if (hasilHapusSOHD) {
                              UtilsAlert.showToast(
                                  "Berhasil hapus order penjualan");
                              Get.back();
                              Get.back();
                              Get.back();
                              loadData();
                            }
                          } else {
                            UtilsAlert.showToast("Tidak dapat di hapus");
                          }
                        } else if (screenAktif.value == 2) {
                          if (statusOutStand == false) {
                            Future<bool> prosesHapusDOHD = HapusDodtController()
                                .hapusFakturDanJldt(dataSelected['NOMOR']);
                            bool hasilHapus = await prosesHapusDOHD;
                            if (hasilHapus) {
                              UtilsAlert.showToast(
                                  "Berhasil hapus nota pengiriman");
                              Get.back();
                              Get.back();
                              Get.back();
                              loadData();
                              getDataAllDOHD();
                            }
                          } else {
                            UtilsAlert.showToast("Tidak dapat di hapus");
                          }
                        } else if (screenAktif.value == 3) {
                          print('hapus faktur penjualan');
                        }
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Button1(
                    textBtn: "Edit",
                    colorBtn: Utility.primaryDefault,
                    colorText: Colors.white,
                    onTap: () async {
                      if (statusOutStand == false) {
                        Get.back();
                        if (screenAktif.value == 3) {
                          Future<List> getDataSI = GetDataController()
                              .getSpesifikData(
                                  "JLHD",
                                  "NOMOR",
                                  dataSelected['NOMOR'],
                                  "get_spesifik_data_transaksi");
                          List hasilCheck = await getDataSI;
                          if (hasilCheck.isNotEmpty) {
                            prosesLanjutkanSoPenjualan(hasilCheck[0]);
                          } else {
                            UtilsAlert.showToast(
                                'Data penjualan tidak di temukan');
                          }
                        } else {
                          prosesLanjutkanSoPenjualan(dataSelected);
                        }
                      } else {
                        UtilsAlert.showToast("Penjualan tidak dapat di edit");
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Button1(
                    textBtn: "Cetak",
                    colorBtn: Utility.primaryDefault,
                    colorText: Colors.white,
                    onTap: () {
                      ButtonSheetController().validasiButtonSheet(
                          "Cetak Faktur",
                          contentCetakPenjualan(dataSelected),
                          "cetak_faktur_penjualan",
                          'Cetak',
                          () async {});
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Button1(
                    textBtn: dataSelected['POSJ'] == '' ||
                            dataSelected['POSJ'] == null
                        ? "Valid"
                        : "Unvalid",
                    colorBtn: Utility.primaryDefault,
                    colorText: Colors.white,
                    onTap: () {
                      var stringJudul = dataSelected['POSJ'] == '' ||
                              dataSelected['POSJ'] == null
                          ? "Valid"
                          : "Unvalid";
                      ButtonSheetController().validasiButtonSheet(
                          "Validasi valid penjualan",
                          Text(
                            "Yakin $stringJudul penjualan ini ?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          "validasi_valid_penjualan",
                          stringJudul, () async {
                        Future<bool> prosesValid = GetDataController()
                            .validPenjualan(stringJudul, dataSelected['NOMOR']);
                        bool hasilProses = await prosesValid;
                        if (hasilProses) {
                          Get.back();
                          Get.back();
                          Get.back();
                          loadData();
                        } else {
                          UtilsAlert.showToast("Gagal valid penjualan");
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget contenthapusOrderPenjualan(dataSelected) {
    return Text(
        "Apa kamu yakin hapus order penjualan ${Utility.convertNoFaktur(dataSelected['NOMOR'])}");
  }

  Widget contentCetakPenjualan(dataSelected) {
    String? jenisCetak;
    bool statusTampilHarga = false;
    bool statusTTDDigital = false;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile(
                    title: Text(
                      "Netto",
                      style: TextStyle(fontSize: Utility.normal),
                    ),
                    value: "netto",
                    groupValue: jenisCetak,
                    onChanged: (value) {
                      setState(() {
                        jenisCetak = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      "Gross",
                      style: TextStyle(fontSize: Utility.normal),
                    ),
                    value: "gross",
                    groupValue: jenisCetak,
                    onChanged: (value) {
                      setState(() {
                        jenisCetak = value.toString();
                      });
                    },
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      "Tampil Harga",
                      style: TextStyle(fontSize: Utility.normal),
                    ),
                    leading: Checkbox(
                      value: statusTampilHarga,
                      onChanged: (value) {
                        setState(() {
                          statusTampilHarga = !statusTampilHarga;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        statusTampilHarga = !statusTampilHarga;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      "TTD Digital",
                      style: TextStyle(fontSize: Utility.normal),
                    ),
                    leading: Checkbox(
                      value: statusTTDDigital,
                      onChanged: (value) {
                        setState(() {
                          statusTTDDigital = !statusTTDDigital;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        statusTTDDigital = !statusTTDDigital;
                      });
                    },
                  )
                ],
              )),
            ],
          ),
          SizedBox(
            height: Utility.medium,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                      margin: const EdgeInsets.only(left: 3, right: 3),
                      decoration: BoxDecoration(
                          borderRadius: Utility.borderStyle4,
                          border: Border.all(color: Utility.primaryDefault)),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            "Urungkan",
                            style: TextStyle(color: Utility.primaryDefault),
                          ),
                        ),
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Button1(
                    colorBtn: Utility.primaryDefault,
                    colorText: Colors.white,
                    textBtn: "Cetak",
                    onTap: () {
                      var menu = screenAktif.value == 1
                          ? "Order Penjualan"
                          : screenAktif.value == 2
                              ? "Nota Pengiriman Barang"
                              : "";
                      CetakPenjualanController().checkingSeluruhKontenCetak(
                          "SOHD",
                          "SODT",
                          dataSelected['NOMOR'],
                          menu,
                          jenisCetak,
                          statusTampilHarga,
                          statusTTDDigital);
                    },
                  ),
                ),
              )
            ],
          )
        ],
      );
    });
  }

  void prosesLanjutkanSoPenjualan(dataSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");

    Future<List> getSalesSpesifik = getDataCt.getSpesifikData(
        "SALESM", "KODE", dataSelected["SALESM"], "get_spesifik_data_master");
    List dataSales = await getSalesSpesifik;
    Future<List> getPelangganSpesifik = getDataCt.getSpesifikData(
        "CUSTOM", "KODE", dataSelected["CUSTOM"], "get_spesifik_data_master");
    List dataPelanggan = await getPelangganSpesifik;

    if (screenAktif.value == 1) {
      dataSohd.value = [dataSelected];
      nomorSoSelected.value = dataSelected["NOMOR"];
      nomoCbSelected.value = "${dataSelected["CB"]}";

      Future<bool> prosesDeviceIp = getDataCt.closePenjualan("SOHD",
          sidebarCt.ipdevice.value, nomorSoSelected.value, "close_sohd");
      bool hasilProsesDevice = await prosesDeviceIp;
      print("ip device $hasilProsesDevice");

      dataSohd.refresh();
      nomorSoSelected.refresh();
      nomoCbSelected.refresh();
    } else if (screenAktif.value == 2) {
      dohdSelected.value = [dataSelected];
      nomorDoSelected.value = dataSelected["NOMOR"];
      nomoDoCbSelected.value = "${dataSelected["CB"]}";

      Future<bool> prosesDeviceIp = getDataCt.closePenjualan("DOHD",
          sidebarCt.ipdevice.value, nomorDoSelected.value, "close_dohd");
      bool hasilProsesDevice = await prosesDeviceIp;
      print("ip device $hasilProsesDevice");

      dohdSelected.refresh();
      nomorDoSelected.refresh();
      nomoDoCbSelected.refresh();
    } else if (screenAktif.value == 3) {
      nomorFakturPenjualanSelected.value = dataSelected["NOMOR"];
      nomoFakturPenjualanCbSelected.value = dataSelected["CB"];
      fakturPenjualanSelected.value = [dataSelected];

      Future<bool> prosesDeviceIp = getDataCt.closePenjualan(
          "JLHD",
          sidebarCt.ipdevice.value,
          nomorFakturPenjualanSelected.value,
          "close_jlhd");
      bool hasilProsesDevice = await prosesDeviceIp;
      print("ip device $hasilProsesDevice");

      fakturPenjualanSelected.refresh();
      nomorFakturPenjualanSelected.refresh();
      nomoFakturPenjualanCbSelected.refresh();
    }

    selectedIdSales.value = dataSales[0]["KODE"];
    selectedNameSales.value = dataSales[0]["NAMA"];
    selectedIdPelanggan.value = dataSelected["CUSTOM"];
    selectedNamePelanggan.value = dataPelanggan[0]["NAMA"];
    wilayahCustomerSelected.value = dataSelected["WILAYAH"];

    selectedIdSales.refresh();
    selectedNameSales.refresh();
    selectedIdPelanggan.refresh();
    selectedNamePelanggan.refresh();
    wilayahCustomerSelected.refresh();

    Future<bool> prosesPilihCabang =
        sidebarCt.pilihCabangSelected(dataSelected["CB"]);
    bool hasilPilihCabang = await prosesPilihCabang;

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
      if (screenAktif.value == 1) {
        Get.to(ItemOrderPenjualan(dataForm: true),
            duration: Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade);
      } else if (screenAktif.value == 2) {
        Get.to(DetailNotaPengirimanBarang(dataForm: true),
            duration: Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade);
      } else if (screenAktif.value == 3) {
        if (dataSelected["REFTR"] == "SI") {
          Get.to(FakturPenjualanSI(dataForm: true),
              duration: Duration(milliseconds: 500),
              transition: Transition.rightToLeftWithFade);
        } else if (dataSelected["REFTR"] == "DO") {}
      }
    }
  }

  void validasiBukaKunci(emailUserLogin, dataSelected, statusOutStand) async {
    Future<bool> prosesValidasi =
        getDataCt.validasiUser(emailUserLogin[0], passwordBukaKunci.value.text);
    bool hasilValidasi = await prosesValidasi;
    if (hasilValidasi) {
      Get.back();
      if (statusOutStand == false) {
        if (screenAktif.value == 3) {
          Future<List> getDataSI = GetDataController().getSpesifikData("JLHD",
              "NOMOR", dataSelected['NOMOR'], "get_spesifik_data_transaksi");
          List hasilCheck = await getDataSI;
          if (hasilCheck.isNotEmpty) {
            prosesLanjutkanSoPenjualan(hasilCheck[0]);
          } else {
            UtilsAlert.showToast('Data penjualan tidak di temukan');
          }
        } else {
          prosesLanjutkanSoPenjualan(dataSelected);
        }
      } else {
        String judul = screenAktif.value == 1
            ? "Order Penjualan"
            : screenAktif.value == 2
                ? "Nota Pengiriman Barang"
                : screenAktif.value == 2
                    ? "Faktur Penjualan"
                    : "";
        ButtonSheetController().validasiButtonSheet(
            judul,
            contentValidasiLanjutkan(dataSelected, statusOutStand),
            "validasi_lanjutkan_orderpenjualan",
            '',
            () {});
      }
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
