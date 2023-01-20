import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
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

  var persenDiskonPesanBarang = TextEditingController(text: "0.0").obs;
  var hargaDiskonPesanBarang = TextEditingController(text: "0.0").obs;
  var persenDiskonPesanBarangView = TextEditingController(text: "0.0").obs;
  var hargaDiskonPesanBarangView = TextEditingController(text: "0.0").obs;

  var ppnPesan = TextEditingController(text: "0.0").obs;
  var ppnHarga = TextEditingController(text: "0.0").obs;
  var ppnPesanView = TextEditingController(text: "0.0").obs;
  var ppnHargaView = TextEditingController(text: "0.0").obs;

  var serviceChargePesan = TextEditingController(text: "0.0").obs;
  var serviceChargeHarga = TextEditingController(text: "0.0").obs;
  var serviceChargePesanView = TextEditingController(text: "0.0").obs;
  var serviceChargeHargaView = TextEditingController(text: "0.0").obs;

  var jumlahPesan = TextEditingController(text: "1").obs;

  Rx<List<String>> typeBarang = Rx<List<String>>([]);

  var statusCari = false.obs;
  var screenList = false.obs;
  var statusHitungHeader = false.obs;
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
  var includePPN = "".obs;
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
      getCabangJikaAdaArsip();
      getKelompokBarang('first');
    } else {
      // arsipController.startLoad();
      var typeLoad = type == "hapus_faktur" ? "hapus_faktur" : "noarsip";
      getCabang(typeLoad);
      getKelompokBarang('first');
    }
    checkArsipFaktur();
    checkSysdata();
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

  void checkSysdata() {
    List dataSysdata = AppData.infosysdatacabang!;
    if (dataSysdata.isNotEmpty) {
      for (var element in dataSysdata) {
        if (element.kode == "037") {
          print('sysdata terpilih ${element.nama}');
          includePPN.value = element.nama;
          includePPN.refresh();
          print('include ppn ${includePPN.value}');
        }
      }
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
          print('akses cabang kamu $listCabang');
          listCabang.refresh();
          getSalesman(type);
        }
      }
    });
  }

  void getCabangJikaAdaArsip() async {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'CABANG',
    };
    var connect = Api.connectionApi("post", body, "cabang");
    var valuConnect = await connect;
    var valueBody = jsonDecode(valuConnect.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
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
      print('akses cabang kamu $listCabang');
      listCabang.refresh();
    }
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
          pelayanSelected.value = "-";
          namaPelanggan.value = "-";
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
          namaPelanggan.value = "-";
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
    listMenu.clear();
    listMenu.refresh();
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
          kategoriBarang.refresh();
          print('load menu first');
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
    print("load menu run");
    var getKode = "";
    for (var element in listKelompokBarang) {
      if (element['NAMA'] == kategoriBarang.value) {
        getKode = element['INISIAL'];
      }
    }
    print('get kode $getKode');
    getMenu(getKode, 'first');
  }

  void getMenu(kodeInisial, type) {
    listMenu.clear();
    listMenu.refresh();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'PROD1',
      'offset': listMenu.length,
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
        List tampungMenu = [];
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
          tampungMenu.add(filter);
        }
        listMenu.value = tampungMenu;
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
    for (var element1 in listMenu) {
      for (var element2 in listKeranjangArsip) {
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

    if (listKeranjangArsip.isNotEmpty) {
      hitungAllArsipMenu();
    }
  }

  void hitungAllArsipMenu() async {
    // print('validasi hitung arsip baru masuk keranjang');

    Future<List> updateInformasiJLHD = GetDataController().getSpesifikData(
        "JLHD", "PK", primaryKeyFaktur.value, "get_spesifik_data_transaksi");
    List infoJlhd = await updateInformasiJLHD;

    // perhitungan HRGTOT
    double subtotal = 0.0;
    double discdHeader = 0.0;
    double dischHeader = 0.0;
    double allQty = 0.0;

    for (var element in listKeranjangArsip) {
      double hargaBarang = double.parse("${element['HARGA']}");
      double persenDiskonBarang = double.parse("${element['DISC1']}");
      double qtyBarang = double.parse("${element['QTY']}");
      var hitungSubtotal =
          qtyBarang * (hargaBarang - (hargaBarang * persenDiskonBarang * 0.01));
      subtotal += hitungSubtotal;
      discdHeader = discdHeader +
          (double.parse("${element['QTY']}") *
              double.parse("${element['DISCD']}"));
      dischHeader = dischHeader +
          (double.parse("${element['QTY']}") *
              double.parse("${element['DISCH']}"));
      allQty += double.parse("${element['QTY']}");

      double discdBarang = double.parse("${element['DISCD']}");
      double dischBarang = double.parse("${element['DISCH']}");

      var hitungDiscnJldt = discdBarang + dischBarang;
      var valueFinalDiscnJldt = hitungDiscnJldt;

      updateJldt(element['NOKEY'], valueFinalDiscnJldt);
    }

    // hitung subtotal
    totalNominalDikeranjang.value = "$subtotal" == "NaN" ? 0.0 : subtotal;
    totalNominalDikeranjang.refresh();

    // all qty
    allQtyJldt.value = allQty;
    allQtyJldt.refresh();

    // diskon header

    var fltr1 = Utility.persenDiskonHeader(
        "${totalNominalDikeranjang.value}", "${infoJlhd[0]["DISCH"]}");

    print('diskon header persen $fltr1');

    persenDiskonPesanBarang.value.text = "$fltr1" == "NaN" ? "0.0" : "$fltr1";
    persenDiskonPesanBarangView.value.text =
        "$fltr1" == "NaN" ? "0.0" : "$fltr1";
    persenDiskonPesanBarang.refresh();
    persenDiskonPesanBarangView.refresh();

    hargaDiskonPesanBarang.value.text = "${infoJlhd[0]["DISCH"]}";
    hargaDiskonPesanBarangView.value.text =
        Utility.rupiahFormat("${infoJlhd[0]["DISCH"]}", "");
    hargaDiskonPesanBarang.refresh();
    hargaDiskonPesanBarangView.refresh();

    // ppn header

    var taxpJLHD = infoJlhd[0]["TAXP"];

    if (taxpJLHD != null || taxpJLHD != "") {
      if (double.parse("$taxpJLHD") > 0.0) {
        print('perhitungan ppn header jalan disini');
        ppnPesan.value.text = "$taxpJLHD";
        ppnPesanView.value.text = "$taxpJLHD";
        ppnPesan.refresh();
        ppnPesanView.refresh();

        var convert1PPN = Utility.nominalPPNHeaderView(
            '${totalNominalDikeranjang.value}',
            persenDiskonPesanBarang.value.text,
            ppnPesan.value.text);

        ppnHarga.value.text = "$convert1PPN";
        ppnHargaView.value.text = convert1PPN.toStringAsFixed(2);
        ppnHarga.refresh();
        ppnHargaView.refresh();
      } else {
        var storageCabang = AppData.cabangSelected;
        List filter = storageCabang.split("-");
        ppnPesan.value.text = filter[4];
        ppnPesanView.value.text = filter[4];
        ppnPesan.refresh();
        ppnPesanView.refresh();

        var convert1PPN = Utility.nominalPPNHeaderView(
            '${totalNominalDikeranjang.value}',
            persenDiskonPesanBarang.value.text,
            ppnPesan.value.text);

        ppnHarga.value.text = "$convert1PPN";
        ppnHargaView.value.text = convert1PPN.toStringAsFixed(2);
        ppnHarga.refresh();
        ppnHargaView.refresh();
      }
    } else {
      var storageCabang = AppData.cabangSelected;
      List filter = storageCabang.split("-");
      ppnPesan.value.text = filter[4];
      ppnPesanView.value.text = filter[4];
      ppnPesan.refresh();
      ppnPesanView.refresh();

      var convert1PPN = Utility.nominalPPNHeaderView(
          '${totalNominalDikeranjang.value}',
          persenDiskonPesanBarang.value.text,
          ppnPesan.value.text);

      ppnHarga.value.text = "$convert1PPN";
      ppnHargaView.value.text = convert1PPN.toStringAsFixed(2);
      ppnHarga.refresh();
      ppnHargaView.refresh();
    }

    // biaya header

    var convert1 = Utility.persenDiskonHeader(
        "${totalNominalDikeranjang.value}", "${infoJlhd[0]["BIAYA"]}");

    serviceChargePesan.value.text = "$convert1" == "NaN" ? "0.0" : "$convert1";
    serviceChargePesanView.value.text =
        "$convert1" == "NaN" ? "0.0" : "$convert1";
    serviceChargePesan.refresh();
    serviceChargePesanView.refresh();

    var convert1Charge = Utility.nominalPPNHeaderView(
        '${totalNominalDikeranjang.value}',
        persenDiskonPesanBarang.value.text,
        serviceChargePesan.value.text);

    serviceChargeHarga.value.text = "$convert1Charge";
    serviceChargeHargaView.value.text = convert1Charge.toStringAsFixed(2);

    // update jlhd

    double discnHeader = discdHeader + dischHeader;
    // print('hasil nominal discd header $discdHeader');
    // print('hasil nominal disch header $dischHeader');
    // print('hasil nominal discn header $discnHeader');
    updateDataJlhd(discdHeader, dischHeader, discnHeader);

    informasiJlhd.value = infoJlhd;
    informasiJlhd.refresh();

    jumlahItemDikeranjang.value = listKeranjangArsip.length;
    jumlahItemDikeranjang.refresh();
    perhitunganHeader();
  }

  void perhitunganHeader() {
    // setting header

    // var hitungDiskonHeader = Utility.nominalDiskonHeader(
    //     "${totalNominalDikeranjang.value}", "${diskonHeader.value}");
    // var hargaSetelahDiskon = totalNominalDikeranjang.value - hitungDiskonHeader;

    // // diskon header
    // persenDiskonPesanBarang.value.text = diskonHeader.value.toStringAsFixed(2);
    // hargaDiskonPesanBarang.value.text = "$hitungDiskonHeader";

    // persenDiskonPesanBarangView.value.text =
    //     diskonHeader.value.toStringAsFixed(2);
    // hargaDiskonPesanBarangView.value.text =
    //     Utility.rupiahFormat("$hitungDiskonHeader", "");

    // // ppn header
    // ppnPesan.value.text = ppnCabang.value.toStringAsFixed(2);
    // var hitungNominalPPn =
    //     Utility.nominalPPNHeader("$hargaSetelahDiskon", "${ppnCabang.value}");
    // ppnHarga.value.text = "$hitungNominalPPn";

    // ppnPesanView.value.text = ppnCabang.value.toStringAsFixed(2);
    // var hitungNominalPPnView =
    //     Utility.nominalPPNHeader("$hargaSetelahDiskon", "${ppnCabang.value}");
    // ppnHargaView.value.text = Utility.rupiahFormat("$hitungNominalPPnView", "");

    // // service header
    // serviceChargePesan.value.text =
    //     serviceChargerCabang.value.toStringAsFixed(2);
    // var hitungNominalService = Utility.nominalPPNHeader(
    //     "$hargaSetelahDiskon", "${serviceChargerCabang.value}");
    // serviceChargeHarga.value.text = "$hitungNominalService";

    // serviceChargePesanView.value.text =
    //     serviceChargerCabang.value.toStringAsFixed(2);
    // var hitungNominalServiceView = Utility.nominalPPNHeader(
    //     "$hargaSetelahDiskon", "${serviceChargerCabang.value}");
    // serviceChargeHargaView.value.text = "$hitungNominalServiceView";

    double convertDiskon =
        Utility.validasiValueDouble(hargaDiskonPesanBarang.value.text);
    double ppnPPN = Utility.validasiValueDouble(ppnPesan.value.text);
    double convertPPN = Utility.validasiValueDouble(ppnHarga.value.text);
    double convertBiaya =
        Utility.validasiValueDouble(serviceChargeHarga.value.text);

    print("subtotal ${totalNominalDikeranjang.value}");
    print("diskon header $convertDiskon");
    print("ppn header $convertPPN");
    print("biaya header $convertBiaya");

    GetDataController().hitungHeader(
        "JLHD",
        nomorFaktur.value,
        "${totalNominalDikeranjang.value}",
        "$convertDiskon",
        "$ppnPPN",
        "$convertPPN",
        "$convertBiaya");
    refreshInfoHeader();
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

  void updateDataJlhd(
    discdHeader,
    dischHeader,
    discnHeader,
  ) {
    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'JLHD',
      'pk': primaryKeyFaktur.value,
      'qty_update_jlhd': '${allQtyJldt.value}',
      'discd_update_jlhd': '$discdHeader',
      'disch_update_jlhd': '$dischHeader',
      'discn_update_jlhd': '$discnHeader',
    };
    var connect = Api.connectionApi("post", body, "update_jlhd");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('hasil update jlhd $valueBody');
        statusHitungHeader.value = false;
        statusHitungHeader.refresh();
      }
    });
  }

  void refreshInfoHeader() {
    persenDiskonPesanBarang.refresh();
    hargaDiskonPesanBarang.refresh();
    persenDiskonPesanBarangView.refresh();
    hargaDiskonPesanBarangView.refresh();

    ppnPesan.refresh();
    ppnHarga.refresh();
    ppnPesanView.refresh();
    ppnHargaView.refresh();

    serviceChargePesan.refresh();
    serviceChargeHarga.refresh();
    serviceChargePesanView.refresh();
    serviceChargeHargaView.refresh();
  }

  void updateJldt(nokey, hitungDiscn) {
    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'JLDT',
      'pk_update_jldt': primaryKeyFaktur.value,
      'nokey_update_jldt': nokey,
      'discn_update_jldt': hitungDiscn,
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
