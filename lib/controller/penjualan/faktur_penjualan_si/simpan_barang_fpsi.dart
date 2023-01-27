import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/faktur_penjualan_si/faktur_penjualan_si_ct.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class simpanBarangFakturPenjualanSIController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var fakturPenjualanSICt = Get.put(FakturPenjualanSIController());
  var sidebarCt = Get.put(SidebarController());

  Future<bool> simpanBarangProses1(
      produkSelected, imeiData, qtySebelumEdit) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Simpan data");

    bool prosesMasukKeranjang = false;

    var filterJml1 = fakturPenjualanSICt.jumlahPesan.value.text;
    var filterJml2 = filterJml1.replaceAll(",", ".");

    double filterJumlahPesan = double.parse(filterJml2);

    var convertTanggal1 = Utility.convertDate4(
        dashboardPenjualanCt.fakturPenjualanSelected[0]["TANGGAL"]);
    var tanggalJlhd = "$convertTanggal1 23:59:59";

    if (filterJumlahPesan <= 0.0) {
      UtilsAlert.showToast("Quantity tidak valid");
      Get.back();
      Get.back();
    } else {
      if (produkSelected[0]['TIPE'] == "1") {
        print('status tipe barang ${produkSelected[0]['TIPE']}');
        Future<bool> proses =
            simpanBarangProses2(produkSelected, imeiData, qtySebelumEdit);
        prosesMasukKeranjang = await proses;
      } else if (produkSelected[0]['TIPE'] == "3") {
        print('status tipe barang ${produkSelected[0]['TIPE']}');
        Future<bool> proses =
            simpanBarangProses2(produkSelected, imeiData, qtySebelumEdit);
        prosesMasukKeranjang = await proses;
      } else {
        Future<List> checkStok = GetDataController().checkStok(
            produkSelected[0]['GROUP'],
            produkSelected[0]['KODE'],
            tanggalJlhd,
            filterJumlahPesan,
            sidebarCt.gudangSelectedSide.value);
        List hasilCheckStok = await checkStok;
        if (hasilCheckStok[0] == true) {
          Future<bool> proses =
              simpanBarangProses2(produkSelected, imeiData, qtySebelumEdit);
          prosesMasukKeranjang = await proses;
        } else {
          Get.back();
          Get.back();
          Get.back();
        }
      }
    }
    return Future.value(prosesMasukKeranjang);
  }

  Future<bool> simpanBarangProses2(
      produkSelected, imeiData, qtySebelumEdit) async {
    bool hasilProsesSimpan = false;

    // check harga jual di edit
    // validasi harga standar jual jika global include ppn
    double convertHargaJual = Utility.convertStringRpToDouble(
        fakturPenjualanSICt.hargaJualPesanBarang.value.text);
    var cabangSelected = sidebarCt.listCabang.firstWhere(
        (el) => el["KODE"] == sidebarCt.cabangKodeSelectedSide.value);
    double hargaJualFinal = 0.0;
    if (fakturPenjualanSICt.includePPN.value == "Y") {
      double hitung1 = convertHargaJual *
          (100 / (100 + double.parse("${cabangSelected['PPN']}")));
      hargaJualFinal = hitung1;
    } else {
      hargaJualFinal = convertHargaJual;
    }

    var hrgJualEditFinal = hargaJualFinal;

    // check nomor urut keranjang
    Future<String> checkNokeyKeranjang = checkNoKey();
    var valueNomorKey = await checkNokeyKeranjang;

    Future<String> checkNorutKeranjang = checkNorut();
    var valueNomorUrut = await checkNorutKeranjang;

    var filterJml1 = fakturPenjualanSICt.jumlahPesan.value.text;
    var filterJml2 = filterJml1.replaceAll(",", ".");
    double filterJumlahPesan = double.parse(filterJml2);

    // INFO JLHD

    Future<List> checkJLHD = GetDataController().getSpesifikData(
        "JLHD",
        "NOMOR",
        dashboardPenjualanCt.fakturPenjualanSelected[0]['NOMOR'],
        "get_spesifik_data_transaksi");
    List hasilJLHD = await checkJLHD;

    // proses IMEI

    if (imeiData.isNotEmpty) {
      List dataInsertJlim = [
        hasilJLHD[0]['PK'],
        sidebarCt.cabangKodeSelectedSide.value,
        hasilJLHD[0]['NOMOR'],
        valueNomorKey,
        imeiData
      ];

      GetDataController().insertJLIM(dataInsertJlim);

      // INSERT PROD2
      List dataInsertPROD2IMEIX = [
        "01",
        hasilJLHD[0]['NOMOR'],
        hasilJLHD[0]['NOMORCB'],
        valueNomorKey,
        sidebarCt.cabangKodeSelectedSide.value,
        hasilJLHD[0]['NOMOR'],
        valueNomorUrut,
        dashboardPenjualanCt.selectedIdPelanggan.value,
        dashboardPenjualanCt.wilayahCustomerSelected.value,
        dashboardPenjualanCt.selectedIdSales.value,
        sidebarCt.gudangSelectedSide.value,
        produkSelected[0]['GROUP'],
        produkSelected[0]['KODE'],
        produkSelected[0]['STDJUAL'],
        sidebarCt.cabangKodeSelectedSide.value,
        imeiData
      ];
      GetDataController().insertPROD2(dataInsertPROD2IMEIX);
      GetDataController().insertIMEIX(dataInsertPROD2IMEIX);
    }

    // KIRIM JLDT

    var filterDisc1 = fakturPenjualanSICt.persenDiskonPesanBarang.value.text ==
            ""
        ? 0
        : double.parse(fakturPenjualanSICt.persenDiskonPesanBarang.value.text);
    var flt3 = fakturPenjualanSICt.nominalDiskonPesanBarang.value.text
        .replaceAll(',', '');
    var flt4 = flt3.replaceAll('.', '');
    var filterDiscd = flt4 == "" ? 0 : flt4;

    List dataInsert = [
      hasilJLHD[0]['PK'],
      "01",
      hasilJLHD[0]['NOMOR'],
      valueNomorUrut,
      valueNomorKey,
      sidebarCt.cabangKodeSelectedSide.value,
      hasilJLHD[0]['NOMOR'],
      valueNomorKey,
      hasilJLHD[0]['CUSTOM'],
      hasilJLHD[0]['WILAYAH'],
      hasilJLHD[0]['SALESM'],
      sidebarCt.gudangSelectedSide.value,
      produkSelected[0]['GROUP'],
      produkSelected[0]['KODE'],
      filterJumlahPesan,
      produkSelected[0]['SAT'],
      hrgJualEditFinal,
      filterDisc1,
      filterDiscd,
      sidebarCt.cabangKodeSelectedSide.value,
      hasilJLHD[0]['NOMORCB'],
      fakturPenjualanSICt.htgBarangSelected.value,
      hrgJualEditFinal,
      fakturPenjualanSICt.pakBarangSelected.value,
      fakturPenjualanSICt.catatan.value.text
    ];

    GetDataController().kirimJLDT(dataInsert);

    // KIRIM PROD 3

    List dataKirimProd3 = [
      {
        "cabang_selected": sidebarCt.cabangKodeSelectedSide.value,
        "nomor": hasilJLHD[0]['NOMOR'],
        "nomorcb": hasilJLHD[0]['NOMORCB'],
        "nourut": valueNomorUrut,
        "nokey": valueNomorKey,
        "nosub": valueNomorKey,
        "noxx": hasilJLHD[0]['NOMOR'],
        "noref": "",
        "ref": "",
        "custom": hasilJLHD[0]['CUSTOM'],
        "wilayah": hasilJLHD[0]['WILAYAH'],
        "salesm": hasilJLHD[0]['SALESM'],
        "gudang": sidebarCt.gudangSelectedSide.value,
        "group": produkSelected[0]['GROUP'],
        "kode": produkSelected[0]['KODE'],
        "tipe": produkSelected[0]['TIPE'],
        "qty": filterJumlahPesan,
        "sat": produkSelected[0]['SAT'],
        "harga": hrgJualEditFinal,
        "htg": fakturPenjualanSICt.htgBarangSelected.value,
        "pak": fakturPenjualanSICt.pakBarangSelected.value,
        "hgpak": hrgJualEditFinal,
      }
    ];
    GetDataController().kirimProd3(dataKirimProd3);

    GetDataController().updateWareStok(
        produkSelected[0]['GROUP'],
        produkSelected[0]['KODE'],
        qtySebelumEdit,
        '$filterJumlahPesan',
        sidebarCt.gudangSelectedSide.value);

    // updateWareStok(produkSelected, filterJumlahPesan, qtySebelumEdit);

    Get.back();
    Get.back();
    Get.back();

    fakturPenjualanSICt.getDataBarang(true);

    return Future.value(true);
  }

  Future<String> checkNoKey() {
    setBusy();
    String norutKeranjang = "";
    if (fakturPenjualanSICt.jldtSelected.isNotEmpty) {
      print(fakturPenjualanSICt.jldtSelected);
      if (fakturPenjualanSICt.jldtSelected.length <= 9) {
        var valueLast = fakturPenjualanSICt.jldtSelected.last;
        var getNoKey = valueLast["NOKEY"];
        var hitung = int.parse(getNoKey) + 1;
        norutKeranjang = "0000$hitung";
      } else if (fakturPenjualanSICt.jldtSelected.length <= 99) {
        var hitung = fakturPenjualanSICt.jldtSelected.length + 1;
        norutKeranjang = "000$hitung";
      } else {
        var hitung = fakturPenjualanSICt.jldtSelected.length + 1;
        norutKeranjang = "00$hitung";
      }
    } else {
      norutKeranjang = "00001";
    }
    setIdle();
    return Future.value(norutKeranjang);
  }

  Future<String> checkNorut() {
    setBusy();
    String norutKeranjang = "";
    if (fakturPenjualanSICt.jldtSelected.isNotEmpty) {
      print(fakturPenjualanSICt.jldtSelected);
      if (fakturPenjualanSICt.jldtSelected.length <= 9) {
        var valueLast = fakturPenjualanSICt.jldtSelected.last;
        var getNoKey = valueLast["NOURUT"];
        var hitung = int.parse(getNoKey) + 1;
        norutKeranjang = "0000$hitung";
      } else if (fakturPenjualanSICt.jldtSelected.length <= 99) {
        var hitung = fakturPenjualanSICt.jldtSelected.length + 1;
        norutKeranjang = "000$hitung";
      } else {
        var hitung = fakturPenjualanSICt.jldtSelected.length + 1;
        norutKeranjang = "00$hitung";
      }
    } else {
      norutKeranjang = "00001";
    }
    setIdle();
    return Future.value(norutKeranjang);
  }
}
