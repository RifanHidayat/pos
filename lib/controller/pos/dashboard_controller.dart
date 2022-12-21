import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

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
  var jumlahArsipFaktur = 0.obs;
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

  // cabang pos variabel
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
    checkArsipFaktur();
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

  void checkArsipFaktur() {
    if (AppData.noFaktur != "") {
      List tampung = AppData.noFaktur.split("|");
      jumlahArsipFaktur.value = tampung.length;
      jumlahArsipFaktur.refresh();
    } else {
      jumlahArsipFaktur.value = 0;
      jumlahArsipFaktur.refresh();
    }
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
          getKelompokBarang(type);
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
        data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
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
        data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
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
        if (type == "arsip") {
          aksiPilihKategoriBarang();
        } else {
          var getFirst = data.first;
          var kodeInisial = getFirst['INISIAL'];
          kategoriBarang.value = getFirst['NAMA'];
          getMenu(kodeInisial, type);
        }
        kategoriBarang.refresh();
        listKelompokBarang.refresh();
      }
    });
  }

  void loadMoreMenu() {
    if (statusCari.value == false) {
      var getKode = "";
      for (var element in listKelompokBarang.value) {
        if (element['NAMA'] == kategoriBarang.value) {
          getKode = element['INISIAL'];
        }
      }
      getMenu(getKode, '');
    }
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
    print('get kode $getKode');
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
          if (listKeranjangArsip.value.isEmpty &&
              nomorFaktur.value == "-" &&
              primaryKeyFaktur.value == "") {
            checkingKeranjang();
          } else {
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
          for (var element1 in listMenu.value) {
            for (var element2 in data) {
              // if ("${element1['GROUP']}${element1['KODE']}" ==
              //     "${element2['GROUP']}${element2['BARANG']}") {
              //   print('data yang sama $element2');
              //   var filter = {
              //     'NORUT': element2['NOURUT'],
              //     'GROUP': element1['GROUP'],
              //     'KODE': element1['KODE'],
              //     'INISIAL': element1['INISIAL'],
              //     'INGROUP': element1['INGROUP'],
              //     'NAMA': element1['NAMA'],
              //     'BARCODE': element1['BARCODE'],
              //     'TIPE': element1['TIPE'],
              //     'SAT': element1['SAT'],
              //     'STDBELI': element1['STDBELI'],
              //     'STDJUAL': element2['HARGA'],
              //     'NAMAGAMBAR': element1['NAMAGAMBAR'],
              //     'MEREK': element1['MEREK'],
              //     'TIPE_PILIHAN': "",
              //     'CATATAN_PEMBELIAN': element2['KETERANGAN'],
              //     'status': true,
              //     'jumlah_beli': element2['QTY'],
              //   };
              //   listKeranjang.value.add(filter);
              //   listKeranjang.refresh();
              //   element1['status'] = true;
              //   element1['jumlah_beli'] = element2['QTY'];
              // }
              kodeCbArsip = element2['CB'];
              gudangArsip = element2['GUDANG'];
              kodeSalesArsip = element2['SALESM'];
            }
          }
          checkingKeranjang();
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
    double hitungJumlahSeluruh = 0.0;
    for (var element1 in listMenu.value) {
      for (var element2 in listKeranjangArsip.value) {
        if ("${element1['GROUP']}${element1['KODE']}" ==
            "${element2['GROUP']}${element2['BARANG']}") {
          element1['status'] = true;
          element1['jumlah_beli'] = element2['QTY'];
          double hitung = double.parse("${element2['QTY']}") *
              double.parse("${element2['STDJUAL']}");
          hitungJumlahSeluruh += hitung;
        }
      }
    }
    jumlahItemDikeranjang.value = listKeranjang.value.length;
    totalNominalDikeranjang.value = hitungJumlahSeluruh;
    if (listKeranjangArsip.isNotEmpty) {
      hitungAllArsipMenu();
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
    double biayaHeader = 0.0;

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
      biayaHeader = biayaHeader + double.parse("${element['BIAYA']}");

      // update jldt
      double hrgSetelahDiskon = finalHitung - dischBarang;
      var hitungPpnJldt =
          Utility.nominalPPNHeader('$hrgSetelahDiskon', '${ppnCabang.value}');
      var hitungServiceJldt = double.parse("${element['BIAYA']}");
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

    // perhitungan diskon header

    if (diskonHeader.value == 0.0) {
      print('disch ${informasiJlhd.value[0]['DISCH']}');
      var fltr1 = Utility.persenDiskonHeader("${totalNominalDikeranjang.value}",
          "${informasiJlhd.value[0]['DISCH']}");

      diskonHeader.value = fltr1.toPrecision(2);
      diskonHeader.refresh();
    }

    var hargaSetelahDiskonHeader = totalNominalDikeranjang.value - dischHeader;

    // perhitungan ppn header

    var nominalPpn = Utility.nominalPPNHeader(
        '$hargaSetelahDiskonHeader', '${informasiJlhd.value[0]['TAXP']}');

    ppnCabang.value = double.parse('${informasiJlhd.value[0]['TAXP']}');
    ppnCabang.refresh();

    // perhitungan service charge

    var convertPersenServiceCharge =
        Utility.persenDiskonHeader("$hargaSetelahDiskonHeader", "$biayaHeader");

    var precisionPersenServiceCharge =
        convertPersenServiceCharge.toPrecision(2);

    serviceChargerCabang.value = precisionPersenServiceCharge;

    serviceChargerCabang.refresh();

    var nominalService = Utility.nominalPPNHeader(
        '$hargaSetelahDiskonHeader', '${serviceChargerCabang.value}');

    var convertServiceChargeNominal = nominalService.toPrecision(2);

    var hargaNetHeader =
        hargaSetelahDiskonHeader + nominalPpn + convertServiceChargeNominal;

    var fixedTaxn = nominalPpn.toPrecision(2);
    var fixedHrgNet = hargaNetHeader.toPrecision(2);

    updateDataJlhd(hargatotjlhd.value, discdHeader, dischHeader, discnHeader,
        fixedTaxn, convertServiceChargeNominal, fixedHrgNet);
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
      }
    });
  }

  void pencarianDataBarang(value) async {
    var valueCari = value.toUpperCase();
    if (valueCari != "") {
      statusCari.value = true;
      Map<String, dynamic> body = {
        'database': AppData.databaseSelected,
        'periode': AppData.periodeSelected,
        'stringTabel': 'PROD1',
        'kode_gudang': gudangSelected.value,
        'value_pencarian': valueCari
      };
      var connect = Api.connectionApi("post", body, "pencarian_data_barang");
      var getValue = await connect;
      var valueBody = jsonDecode(getValue.body);
      List data = valueBody['data'];
      loadingString.value =
          data.isEmpty ? "Tidak ada barang" : "Sedang memuat...";
      List tmp1 = [];
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
        tmp1.add(filter);
      }
      listMenu.value = tmp1;
      listMenu.refresh();
      viewButtonKeranjang.value = true;
      viewButtonKeranjang.refresh();
      for (var element1 in listMenu.value) {
        for (var element2 in listKeranjangArsip.value) {
          if ("${element1['GROUP']}${element1['KODE']}" ==
              "${element2['GROUP']}${element2['BARANG']}") {
            element1['status'] = true;
            element1['jumlah_beli'] = element2['QTY'];
          }
        }
      }
    } else {
      print('tidak proses cari');
    }
  }
}
