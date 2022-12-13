import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/masuk_keranjang_controller.dart';
import 'package:siscom_pos/screen/auth/login.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class DashbardController extends BaseController {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController controllerScroll = ScrollController();

  var arsipController = Get.put(ArsipFakturController());

  var cari = TextEditingController().obs;
  var reff = TextEditingController().obs;
  var catatanPembelian = TextEditingController().obs;
  var catatanKeranjang = TextEditingController().obs;
  var keteranganInsertFaktur = TextEditingController().obs;
  var hargaJualPesanBarang = TextEditingController().obs;

  var persenDiskonPesanBarang = TextEditingController().obs;
  var hargaDiskonPesanBarang = TextEditingController().obs;
  var ppnPesan = TextEditingController().obs;
  var ppnHarga = TextEditingController().obs;
  var serviceChargePesan = TextEditingController().obs;
  var serviceChargeHarga = TextEditingController().obs;

  var jumlahPesan = TextEditingController(text: "1").obs;

  Rx<List<String>> typeBarang = Rx<List<String>>([]);

  var statusCari = false.obs;
  var screenList = false.obs;
  var viewButtonKeranjang = true.obs;

  var pageLoad = 12.obs;
  var jumlahTotalKeranjang = 0.obs;
  var totalPesan = 0.0.obs;
  var totalPesanNoEdit = 0.0.obs;
  var numberViewGridView = 3.obs;
  var aktifButton = 0.obs;
  var tipeBarangDetail = 0.obs;
  var ppnCabang = 0.0.obs;
  var serviceChargerCabang = 0.0.obs;

  var jumlahItemDikeranjang = 0.obs;
  var hargatotjlhd = 0.0.obs;
  var totalNominalDikeranjang = 0.0.obs;
  var allQtyJldt = 0.0.obs;
  var diskonHeader = 0.0.obs;

  var indexScroll = 0.0.obs;

  // SALESM variabel
  var kodePelayanSelected = "".obs;
  var pelayanSelected = "".obs;

  // GROUP variabel
  var kategoriBarang = "".obs;

  // CUSTOMER variabel
  var namaPelanggan = "".obs;
  var customSelected = "".obs;
  var wilayahCustomerSelected = "".obs;

  // cabang variabel
  var cabangKodeSelected = "".obs;
  var cabangNameSelected = "".obs;
  var gudangSelected = "".obs;
  var midQrisCabang = "".obs;

  // ukuran variabel
  var htgUkuran = "".obs;
  var pakUkuran = "".obs;

  // GLOBAL
  var typeBarangSelected = "".obs;
  var nomorFaktur = "-".obs;
  var primaryKeyFaktur = "".obs;
  var nomorCbLastSelected = "".obs;
  var nomorKey = "".obs;
  var nomorOrder = "".obs;
  var nomorMeja = "".obs;
  var loadingString = "Sedang Memuat".obs;

  var listCabang = [].obs;
  var listSalesman = [].obs;
  var listKelompokBarang = [].obs;
  var listMenu = [].obs;
  var listKeranjang = [].obs;
  var listKeranjangArsip = [].obs;
  var listTypeBarang = [].obs;
  var listPelanggan = [].obs;
  var listfakturArsip = [].obs;
  var informasiJlhd = [].obs;

  void startLoad(type) {
    if (AppData.noFaktur != "") {
      // arsipController.startLoad();
      var getValue1 = AppData.noFaktur.split("|");
      var getValue2 = getValue1[0].split("-");
      checkingJlhdArsip();
    } else {
      // arsipController.startLoad();
      var typeLoad = type == "hapus_faktur" ? "hapus_faktur" : "noarsip";
      getCabang(typeLoad);
      getKelompokBarang('first');
    }
  }

  void mulaiScroll() {
    viewButtonKeranjang.value = false;
    viewButtonKeranjang.refresh();
  }

  void selesaiScroll() async {
    await Future.delayed(const Duration(seconds: 1));
    viewButtonKeranjang.value = true;
    viewButtonKeranjang.refresh();
  }

  void checkingData() {
    if (AppData.noFaktur != "") {
      var getValue1 = AppData.noFaktur.split("|");
      var getValue2 = getValue1[0].split("-");
      nomorFaktur.value = getValue2[0];
      primaryKeyFaktur.value = getValue2[1];
      nomorCbLastSelected.value = getValue2[2];
      nomorOrder.value = getValue2[3];
      listfakturArsip.value = getValue1;
    } else {
      nomorFaktur.value = "-";
      primaryKeyFaktur.value = "";
      // print("data faktur tidak ada");
    }
  }

  void gantiLanjutkanArsipFaktur(noFaktur) {
    setBusy();
    List tampung = [];
    var getValue1 = AppData.noFaktur.split("|");
    for (var element in getValue1) {
      var listFilter = element.split("-");
      var data = {
        "no_faktur": listFilter[0],
        "key": listFilter[1],
        "no_cabang": listFilter[2],
        "nomor_antrian": listFilter[3],
      };
      tampung.add(data);
    }
    if (tampung.isNotEmpty) {
      var filterOnce =
          tampung.firstWhere((element) => element['no_faktur'] == noFaktur);
      nomorFaktur.value = filterOnce['no_faktur'];
      primaryKeyFaktur.value = filterOnce['key'];
      nomorCbLastSelected.value = filterOnce['no_cabang'];
      nomorOrder.value = filterOnce['nomor_antrian'];
      checkingJlhdArsip();
      getKelompokBarang('first');
      Get.back();
      Get.back();
    }
    setIdle();
  }

  void checkingJlhdArsip() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'key_faktur': primaryKeyFaktur.value,
    };
    var connect = Api.connectionApi("post", body, "get_once_jlhd");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        informasiJlhd.value = data;
        informasiJlhd.refresh();
        getCabang("arsip");
      }
    });
  }

  void getCabang(type) {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'CABANG',
    };
    var connect = Api.connectionApi("post", body, "cabang");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        if (type == "arsip") {
          var filterDataCabang = [];
          for (var element in data) {
            if ("${element["KODE"]}" == "${informasiJlhd[0]["CB"]}") {
              filterDataCabang.add(element);
            }
          }
          cabangKodeSelected.value = "${filterDataCabang[0]["KODE"]}";
          cabangNameSelected.value = filterDataCabang[0]["NAMA"];
          customSelected.value = "${informasiJlhd[0]["CUSTOM"]}";
          gudangSelected.value = "${filterDataCabang[0]["GUDANG"]}";
          ppnCabang.value = double.parse("${filterDataCabang[0]["PPN"]}");
          serviceChargerCabang.value =
              double.parse("${filterDataCabang[0]["SCHARGE"]}");
          midQrisCabang.value = "${filterDataCabang[0]["MID"]}";

          cabangKodeSelected.refresh();
          cabangNameSelected.refresh();
          customSelected.refresh();
          gudangSelected.refresh();
          ppnCabang.refresh();
          midQrisCabang.refresh();
          serviceChargerCabang.refresh();

          aksiGetSalesman(cabangKodeSelected.value, informasiJlhd[0]["SALESM"],
              'loadArsip');
          aksiGetCustomer(informasiJlhd[0]["SALESM"], 'loadArsip');
          getKelompokBarang('first');
        } else {
          var sysUser = AppData.sysuserInformasi.split("-");
          var hakAksesCabang = sysUser[3].split(" ");
          List filter = [];
          for (var element in data) {
            for (var element1 in hakAksesCabang) {
              if (element1 == element["KODE"]) {
                filter.add(element);
              }
            }
          }
          listCabang.value = filter;
          listCabang.refresh();
          getSalesman(type);
        }
      }
    });
  }

  void pilihGudang(nama) {
    var tampungString = "";
    listCabang.forEach((element) {
      if (element['NAMA'] == nama) {
        tampungString = element['GUDANG'];
      }
    });
    gudangSelected.value = tampungString;
    // print("gudang selected ${gudangSelected.value}");
  }

  void getSalesman(type) {
    var storageCabang = AppData.cabangSelected;
    var filter = storageCabang.split("-");

    var filterDataCabang = [];
    for (var element in listCabang.value) {
      if ("${element["KODE"]}" == filter[0]) {
        filterDataCabang.add(element);
      }
    }

    if (type != "hapus_faktur") {
      cabangKodeSelected.value = "${filterDataCabang[0]["KODE"]}";
      cabangNameSelected.value = filterDataCabang[0]["NAMA"];
      gudangSelected.value = "${filterDataCabang[0]["GUDANG"]}";
      ppnCabang.value = double.parse("${filterDataCabang[0]["PPN"]}");
      serviceChargerCabang.value =
          double.parse("${filterDataCabang[0]["SCHARGE"]}");

      cabangKodeSelected.refresh();
      cabangNameSelected.refresh();
      gudangSelected.refresh();
      ppnCabang.refresh();
      serviceChargerCabang.refresh();
      aksiGetSalesman(filter[0], '', '');
    } else {
      aksiGetSalesman(cabangKodeSelected.value, '', '');
    }
  }

  void aksiGetSalesman(kode, kodeSales, stringType) {
    listSalesman.value.clear();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SALESM',
      'kode_cabang': '$kode',
    };
    var connect = Api.connectionApi("post", body, "salesman");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        listSalesman.value = data;
        if (data.isEmpty) {
          pelayanSelected.value = "Data pelayan kosong";
          namaPelanggan.value = "Data Pelanggan kosong";
          UtilsAlert.showToast("Tidak ada data sales");
        } else {
          if (stringType != 'loadArsip') {
            var getFirst = data.first;
            pelayanSelected.value = getFirst['NAMA'];
            kodePelayanSelected.value = getFirst['KODE'];
            if (getFirst['KODE'] != "" || getFirst['KODE'] != null) {
              aksiGetCustomer(getFirst['KODE'], stringType);
            } else {
              UtilsAlert.showToast("kode sales tidak ada");
            }
          }
        }
        namaPelanggan.refresh();
        kodePelayanSelected.refresh();
        pelayanSelected.refresh();
        listSalesman.refresh();
        if (stringType == 'loadArsip') {
          for (var element in listSalesman.value) {
            if ("${element['KODE']}" == "$kodeSales") {
              pelayanSelected.value = element['NAMA'];
              kodePelayanSelected.value = element['KODE'];
              pelayanSelected.refresh();
              kodePelayanSelected.refresh();
            }
          }
        }
      } else {
        UtilsAlert.showToast("Terjadi kesalahan");
      }
    });
  }

  void aksiGetCustomer(kode, stringType) {
    listPelanggan.value.clear();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'CUSTOM',
      'kode_sales': '$kode',
    };
    var connect = Api.connectionApi("post", body, "pelanggan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        listPelanggan.value = data;
        if (data.isEmpty) {
          namaPelanggan.value = "Data pelanggan kosong";
        } else {
          if (stringType != 'loadArsip') {
            var getFirst = data.first;
            namaPelanggan.value = getFirst['NAMA'];
            customSelected.value = getFirst['KODE'];
            wilayahCustomerSelected.value = getFirst['WILAYAH'];
          }
        }
        namaPelanggan.refresh();
        customSelected.refresh();
        wilayahCustomerSelected.refresh();
        listPelanggan.refresh();
        if (stringType == 'loadArsip') {
          for (var element in listPelanggan.value) {
            if ("${element["KODE"]}" == "${customSelected.value}") {
              namaPelanggan.value = element['NAMA'];
              wilayahCustomerSelected.value = element['WILAYAH'];
            }
          }
        }
        namaPelanggan.refresh();
        wilayahCustomerSelected.refresh();
      } else {
        UtilsAlert.showToast("Terjadi kesalahan");
      }
    });
  }

  void getKelompokBarang(type) {
    listMenu.value.clear();
    listMenu..refresh();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'GROUP',
    };
    var connect = Api.connectionApi("post", body, "kelompok_barang");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        listKelompokBarang.value = data;
        listKelompokBarang.value.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
        var getFirst = data.first;
        var kodeInisial = getFirst['INISIAL'];
        kategoriBarang.value = getFirst['NAMA'];
        getMenu(kodeInisial, type);
        kategoriBarang.refresh();
        listKelompokBarang.refresh();
      }
    });
  }

  void loadMoreMenu() {
    var getKode = "";
    for (var element in listKelompokBarang.value) {
      if (element['NAMA'] == kategoriBarang.value) {
        getKode = element['INISIAL'];
      }
    }
    getMenu(getKode, '');
  }

  void changeTampilanList() {
    screenList.value = !screenList.value;
    screenList.refresh();
  }

  void aksiPilihKategoriBarang() {
    listMenu.value.clear();
    listMenu.refresh();
    var getKode = "";
    for (var element in listKelompokBarang.value) {
      if (element['NAMA'] == kategoriBarang.value) {
        getKode = element['INISIAL'];
      }
    }
    getMenu(getKode, '');
  }

  void getMenu(kodeInisial, type) {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'PROD1',
      'offset': listMenu.value.length,
      'limit': 12,
      'inisial': '$kodeInisial',
      'gudang': '${gudangSelected.value}',
    };
    var connect = Api.connectionApi("post", body, "getMenu");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        loadingString.value =
            data.isEmpty ? "Tidak ada barang" : "Sedang memuat...";
        for (var element in data) {
          var filter = {
            'GROUP': element['GROUP'],
            'KODE': element['KODE'],
            'INISIAL': element['INISIAL'],
            'INGROUP': element['INGROUP'],
            'NAMA': element['NAMA'],
            'BARCODE': element['BARCODE'],
            'TIPE': element['TIPE'],
            'SAT': element['SAT'],
            'STDBELI': element['STDBELI'],
            'STDJUAL': element['STDJUAL'],
            'NAMAGAMBAR': element['NAMAGAMBAR'],
            'MEREK': element['MEREK'],
            'STOKWARE': element['STOKWARE'],
            'nama_merek': element['nama_merek'],
            'status': false,
            'jumlah_beli': 0,
          };
          listMenu.value.add(filter);
        }
        listMenu.refresh();
        viewButtonKeranjang.value = true;
        viewButtonKeranjang.refresh();
        if (type != 'simpan_faktur') {
          if (listKeranjang.value.isEmpty &&
              nomorFaktur.value == "" &&
              primaryKeyFaktur.value == "") {
            checkingKeranjang();
            print('proses simpan faktur');
          } else {
            // print('masuk ke sini');
            if (nomorFaktur.value != "-" && primaryKeyFaktur.value != "") {
              checkingDetailKeranjangArsip(primaryKeyFaktur.value);
            }
          }
        }

        refreshController.loadComplete();
      } else {
        UtilsAlert.showToast("Terjadi kesalahan");
      }
    });
  }

  void checkingDetailKeranjangArsip(key) {
    print("jalan lagi check detail keranjang");
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'key': '$key',
    };
    var connect = Api.connectionApi("post", body, "detail_arsip_barang");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        setBusy();
        if (data.isNotEmpty) {
          var kodeCbArsip = "";
          var gudangArsip = "";
          var kodeSalesArsip = "";
          listKeranjangArsip.value = data;
          listKeranjangArsip.refresh();
          checkingKeranjang();
          for (var element1 in listMenu.value) {
            for (var element2 in data) {
              if ("${element1['GROUP']}${element1['KODE']}" ==
                  "${element2['GROUP']}${element2['BARANG']}") {
                element1['status'] = true;
                element1['jumlah_beli'] = element2['QTY'];
                var filter = {
                  'NORUT': element2['NOURUT'],
                  'GROUP': element1['GROUP'],
                  'KODE': element1['KODE'],
                  'INISIAL': element1['INISIAL'],
                  'INGROUP': element1['INGROUP'],
                  'NAMA': element1['NAMA'],
                  'BARCODE': element1['BARCODE'],
                  'TIPE': element1['TIPE'],
                  'SAT': element1['SAT'],
                  'STDBELI': element1['STDBELI'],
                  'STDJUAL': element2['HARGA'],
                  'NAMAGAMBAR': element1['NAMAGAMBAR'],
                  'MEREK': element1['MEREK'],
                  'TIPE_PILIHAN': "",
                  'CATATAN_PEMBELIAN': element2['KETERANGAN'],
                  'status': true,
                  'jumlah_beli': element2['QTY'],
                };
                listKeranjang.value.add(filter);
                listKeranjang.refresh();
              }
              kodeCbArsip = element2['CB'];
              gudangArsip = element2['GUDANG'];
              kodeSalesArsip = element2['SALESM'];
            }
          }
          // validasiCabangsdPelanggan(kodeCbArsip, gudangArsip, kodeSalesArsip);
        } else {
          checkingKeranjang();
        }
        setIdle();
      } else {
        UtilsAlert.showToast("Terjadi kesalahan, periksa koneksi anda");
      }
    });
  }

  void checkingKeranjang() {
    if (listKeranjangArsip.isNotEmpty) {
      hitungAllArsipMenu();
    } else {
      double hitungJumlahSeluruh = 0.0;
      for (var element1 in listMenu.value) {
        for (var element2 in listKeranjang.value) {
          if ("${element1['INGROUP']}" == "${element2['INGROUP']}" &&
              "${element1['GROUP']}${element1['KODE']}" ==
                  "${element2['GROUP']}${element2['KODE']}") {
            element1['status'] = true;
            element1['jumlah_beli'] = element2['jumlah_beli'];
            double hitung = double.parse("${element2['jumlah_beli']}") *
                double.parse("${element2['STDJUAL']}");
            hitungJumlahSeluruh += hitung;
          }
        }
      }
      jumlahItemDikeranjang.value = listKeranjang.value.length;
      totalNominalDikeranjang.value = hitungJumlahSeluruh;
    }

    listKeranjang.refresh();
    listMenu.refresh();
    jumlahItemDikeranjang.refresh();
    totalNominalDikeranjang.refresh();
  }

  void hitungAllArsipMenu() async {
    print('validasi hitung arsip baru masuk keranjang');
    double subtotalKeranjang = 0.0;
    double hargaTotheader = 0.0;
    double qtyallheader = 0.0;
    double discdHeader = 0.0;
    double dischHeader = 0.0;
    double discnHeader = 0.0;

    for (var element in listKeranjangArsip.value) {
      double hargaBarang = double.parse("${element['HARGA']}");
      double discdBarang = double.parse("${element['DISCD']}");
      double dischBarang = double.parse("${element['DISCH']}");
      double qtyBarang = double.parse("${element['QTY']}");
      var hitung1 = hargaBarang * qtyBarang;
      var hitung2 = discdBarang * qtyBarang;
      var finalHitung = hitung1 - hitung2;
      var hitungDiscn = hitung2 + dischBarang;
      var hitungDiscnJldt =
          discdBarang.toPrecision(2) + dischBarang.toPrecision(2);

      subtotalKeranjang = subtotalKeranjang + finalHitung;
      hargaTotheader = hargaTotheader + hitung1;
      qtyallheader = qtyallheader + qtyBarang;
      discdHeader = discdHeader + hitung2;
      dischHeader = dischHeader + dischBarang;
      discnHeader = discnHeader + hitungDiscn;

      // update jldt
      double hrgSetelahDiskon = finalHitung - dischBarang;
      var hitungPpnJldt =
          Utility.nominalPPNHeader('$hrgSetelahDiskon', '${ppnCabang.value}');
      var hitungServiceJldt = Utility.nominalPPNHeader(
          '$hrgSetelahDiskon', '${serviceChargerCabang.value}');
      var valueFinalDiscnJldt = hitungDiscnJldt.toPrecision(2);
      var valueFinalPpnJldt = hitungPpnJldt.toPrecision(2);
      updateJldt(element['NOKEY'], valueFinalDiscnJldt, valueFinalPpnJldt,
          hitungServiceJldt);
    }

    jumlahItemDikeranjang.value = listKeranjangArsip.value.length;
    jumlahItemDikeranjang.refresh();

    totalNominalDikeranjang.value = subtotalKeranjang;
    totalNominalDikeranjang.refresh();

    hargatotjlhd.value = hargaTotheader;
    hargatotjlhd.refresh();

    allQtyJldt.value = qtyallheader;
    allQtyJldt.refresh();

    // print('hasil perhitungan keranjang');
    // print(jumlahItemDikeranjang.value);
    // print(hargatotjlhd.value);
    // print("discd headerr $discdHeader");
    // print("discn header $discnHeader");
    // print("total nominal subtotal ${totalNominalDikeranjang.value}");
    // print("DISKON header ${diskonHeader.value}");
    // print("TAXP header ${ppnCabang.value}");
    // print("charge header ${serviceChargerCabang.value}");

    var hargaSetelahDiskonHeader = totalNominalDikeranjang.value - dischHeader;
    var nominalPpn = Utility.nominalPPNHeader(
        '${hargaSetelahDiskonHeader}', '${ppnCabang.value}');
    var nominalService = Utility.nominalPPNHeader(
        '${hargaSetelahDiskonHeader}', '${serviceChargerCabang.value}');

    var hargaNetHeader = hargaSetelahDiskonHeader + nominalPpn + nominalService;

    if (diskonHeader.value == 0.0) {
      print('harga setelah diskon $hargaSetelahDiskonHeader');
      print('disch ${informasiJlhd.value[0]['DISCH']}');
      var fltr1 = Utility.persenDiskonHeader(
          "$hargaSetelahDiskonHeader", "${informasiJlhd.value[0]['DISCH']}");

      diskonHeader.value = fltr1.toPrecision(2);
    }

    ppnCabang.value =
        Utility.convertStringRpToDouble("${informasiJlhd.value[0]['TAXP']}");
    serviceChargerCabang.value = Utility.persenDiskonHeader(
        "$hargaSetelahDiskonHeader", "${informasiJlhd.value[0]['BIAYA']}");
    diskonHeader.refresh();
    ppnCabang.refresh();
    serviceChargerCabang.refresh();

    var fixedTaxn = nominalPpn.toPrecision(2);
    var fixedHrgNet = hargaNetHeader.toPrecision(2);

    updateDataJlhd(hargatotjlhd.value, discdHeader, dischHeader, discnHeader,
        fixedTaxn, nominalService, fixedHrgNet);
  }

  void validasiCabangsdPelanggan(kodeCbArsip, gudangArsip, kodeSalesArsip) {
    for (var element in listCabang.value) {
      if (element['KODE'] == kodeCbArsip) {
        cabangKodeSelected.value = element['KODE'];
        cabangNameSelected.value = element['NAMA'];
        cabangKodeSelected.refresh();
        cabangNameSelected.refresh();
      }
    }
    gudangSelected.value = gudangArsip;
    aksiGetSalesman(kodeCbArsip, kodeSalesArsip, 'loadArsip');
  }

  void hitungPesanan(status) {
    if (status == false) {
      totalPesan.value = totalPesan.value - 1;
    } else {
      totalPesan.value = totalPesan.value + 1;
    }
    totalPesan.refresh();
  }

  void updateDataJlhd(hargatotjlhd, discdHeader, dischHeader, discnHeader,
      nominalPpn, nominalService, hargaNetHeader) {
    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'JLHD',
      'pk': primaryKeyFaktur.value,
      'qty_update_jlhd': '${allQtyJldt.value}',
      'hrgtot_update_jlhd': '$hargatotjlhd',
      'discd_update_jlhd': '$discdHeader',
      'disch_update_jlhd': '$dischHeader',
      'discn_update_jlhd': '$discnHeader',
      'service_update_jlhd': '$nominalService',
      'ppn_update_jlhd': '$nominalPpn',
      'hrgnet_update_jlhd': '$hargaNetHeader',
    };
    var connect = Api.connectionApi("post", body, "update_jlhd");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print('update data jlhd');
        print(valueBody);
      }
    });
  }

  void updateJldt(nokey, hitungDiscn, hitungPpnJldt, hitungServiceJldt) {
    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'JLDT',
      'pk_update_jldt': primaryKeyFaktur.value,
      'nokey_update_jldt': nokey,
      'discn_update_jldt': hitungDiscn,
      'ppn_update_jldt': hitungPpnJldt,
      'service_update_jldt': hitungServiceJldt,
    };
    var connect = Api.connectionApi("post", body, "update_jldt");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print('update data jldt');
        print(valueBody);
      }
    });
  }

  void getAkhirNomorFaktur() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
    };
    var connect = Api.connectionApi("post", body, "get_last_faktur");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        var tanggalLastFaktur = data[0]['TANGGAL'];
        var nomorAntriLastFaktur = data[0]['NOMORANTRI'];
        var getfaktur = data[0]['NOMOR'];
        var filter = getfaktur.substring(2);
        var filter2 = int.parse(filter) + 1;
        var lastFaktur = "SI$filter2";
        var dt = DateTime.now();

        var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
        var inputDate = Utility.convertDate4(tanggalLastFaktur);
        if (tanggalNow == inputDate) {
          // print(nomorAntriLastFaktur);
          if (nomorAntriLastFaktur == null || nomorAntriLastFaktur == "") {
            print('nomor antri tidak valid');
            nomorOrder.value = "${DateFormat('yyyyMMdd').format(dt)}001";
          } else {
            print('nomor antri valid');
            var ft1 =
                nomorAntriLastFaktur.substring(nomorAntriLastFaktur.length - 3);
            var ft2 = int.parse(ft1) + 1;
            if (ft2 <= 9) {
              nomorOrder.value = "${DateFormat('yyyyMMdd').format(dt)}00$ft2";
            } else if (ft2 <= 99) {
              nomorOrder.value = "${DateFormat('yyyyMMdd').format(dt)}0$ft2";
            } else if (ft2 < 999) {
              nomorOrder.value = "${DateFormat('yyyyMMdd').format(dt)}$ft2";
            }
          }
        } else {
          nomorOrder.value = "${DateFormat('yyyyMMdd').format(dt)}001";
        }
        nomorOrder.refresh();
        // print(getfaktur);
        // print(filter2);
        // print(lastFaktur);
        getAkhirNomorCBJLHD(lastFaktur);
      }
    });
  }

  void getAkhirNomorCBJLHD(lastFaktur) {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'kode_cabang': '${cabangKodeSelected.value}',
    };
    var connect = Api.connectionApi("post", body, "get_last_nomorcb_jlhd");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        var getNomorCb = data[0]['NOMORCB'];
        var filter = getNomorCb.substring(2);
        var filter2 = int.parse(filter) + 1;
        var lastNomorCB = "SI$filter2";
        insertFakturBaru(lastFaktur, lastNomorCB);
      }
    });
  }

  void insertFakturBaru(lastFaktur, lastNomorCB) {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";
    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'jlhd_cabang': "01",
      'jlhd_nomor': "$lastFaktur",
      'jlhd_reff': "${reff.value.text}",
      'jlhd_tanggal': "$tanggalNow",
      'jlhd_tglinv': "$tanggalNow",
      'jlhd_term': "0",
      'jlhd_tgltjp': "$tanggalNow",
      'jlhd_custom': "${customSelected.value}",
      'jlhd_wilayah': "${wilayahCustomerSelected.value}",
      'jlhd_salesm': "${kodePelayanSelected.value}",
      'jlhd_uang': "RP",
      'jlhd_kurs': "1",
      'jlhd_ket1': "${keteranganInsertFaktur.value.text}",
      'jlhd_cb': "${cabangKodeSelected.value}",
      'jlhd_doe': tanggalDanJam,
      'jlhd_toe': jamTransaksi,
      'jlhd_loe': tanggalDanJam,
      'jlhd_deo': dataInformasiSYSUSER[0],
      'jlhd_nomorcb': "$lastNomorCB",
      'jlhd_nomorantri': "${nomorOrder.value}",
      'jlhd_taxp': "${ppnCabang.value}"
    };
    var connect = Api.connectionApi("post", body, "buat_faktur");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          getAkhirNomorFaktur();
        } else {
          nomorFaktur.value = lastFaktur;
          primaryKeyFaktur.value = "${valueBody['primaryKey']}";
          nomorCbLastSelected.value = lastNomorCB;
          reff.value.text = "";
          keteranganInsertFaktur.value.text = "";
          if (AppData.noFaktur != "") {
            AppData.noFaktur =
                "${AppData.noFaktur}|${nomorFaktur.value}-${primaryKeyFaktur.value}-$lastNomorCB-${nomorOrder.value}";
          } else {
            AppData.noFaktur =
                "${nomorFaktur.value}-${primaryKeyFaktur.value}-$lastNomorCB-${nomorOrder.value}";
          }
          nomorFaktur.refresh();
          primaryKeyFaktur.refresh();
          print("nomor faktur ${nomorFaktur.value}");
          print("key faktur ${primaryKeyFaktur.value}");
          checkingJlhdArsip();
          UtilsAlert.showToast("Berhasil buat faktur");
          Get.back();
          Get.back();
        }
      }
    });
  }

  void logout() {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: ModalPopup(
            // our custom dialog
            title: "Peringatan",
            content: "Yakin Keluar Akun",
            positiveBtnText: "Keluar",
            negativeBtnText: "Kembali",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: () {
              AppData.databaseSelected = "";
              AppData.periodeSelected = "";
              AppData.cabangSelected = "";
              Get.offAll(Login());
            },
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }
}
