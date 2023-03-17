import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/faktur_penjualan_si/buttom_sheet/fpsi_pesan_barang_ct.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class FakturPenjualanSIController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var getDataCt = Get.put(GetDataController());
  var sidebarCt = Get.put(SidebarController());

  var jumlahPesan = TextEditingController().obs;
  var hargaJualPesanBarang = TextEditingController().obs;

  var persenDiskonPesanBarang = TextEditingController().obs;
  var nominalDiskonPesanBarang = TextEditingController().obs;

  var persenDiskonHeaderRincian = TextEditingController(text: "0.0").obs;
  var nominalDiskonHeaderRincian = TextEditingController(text: "0.0").obs;
  var persenDiskonHeaderRincianView = TextEditingController(text: "0.0").obs;
  var nominalDiskonHeaderRincianView = TextEditingController(text: "0.0").obs;

  var persenPPNHeaderRincian = TextEditingController(text: "0.0").obs;
  var nominalPPNHeaderRincian = TextEditingController(text: "0.0").obs;
  var persenPPNHeaderRincianView = TextEditingController(text: "0.0").obs;
  var nominalPPNHeaderRincianView = TextEditingController(text: "0.0").obs;

  var nominalOngkosHeaderRincian = TextEditingController().obs;
  var nominalOngkosHeaderRincianView = TextEditingController().obs;

  var catatan = TextEditingController().obs;
  var keterangan1 = TextEditingController().obs;
  var keterangan2 = TextEditingController().obs;
  var keterangan3 = TextEditingController().obs;
  var keterangan4 = TextEditingController().obs;

  Rx<List<String>> typeBarang = Rx<List<String>>([]);

  var listBarang = [].obs;
  var barangTerpilih = [].obs;
  var jldtSelected = [].obs;
  var listTypeBarang = [].obs;

  var statusBack = false.obs;
  var statusInformasiSI = false.obs;
  var statusEditBarang = false.obs;
  var statusAksiItemFakturPenjualan = false.obs;
  var statusJLDTKosong = false.obs;

  var totalPesanBarang = 0.0.obs;
  var totalPesanBarangNoEdit = 0.0.obs;
  var totalNetto = 0.0.obs;
  var hrgtotSohd = 0.0.obs;
  var subtotal = 0.0.obs;
  var allQtyBeli = 0.0.obs;

  var typeFocus = "".obs;
  var typeBarangSelected = "".obs;
  var htgBarangSelected = "".obs;
  var pakBarangSelected = "".obs;
  var typeAksi = "".obs;
  var includePPN = "".obs;

  void getDataBarang(status) async {
    listBarang.value.clear();
    barangTerpilih.value.clear();
    jldtSelected.value.clear();
    listBarang.refresh();
    barangTerpilih.refresh();
    jldtSelected.refresh();
    statusAksiItemFakturPenjualan.value = status;
    statusAksiItemFakturPenjualan.refresh();
    checkSysdata();
    Future<List> prosesGetDataBarang = getDataCt.getAllBarang();
    List data = await prosesGetDataBarang;
    if (data.isNotEmpty) {
      listBarang.value = data;
      listBarang.refresh();
      loadDataJLDT();
      // if (status == true) {
      //   loadDataJLDT();
      // } else {
      //   statusJLDTKosong.value = true;
      //   statusJLDTKosong.refresh();
      // }
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

  void loadDataJLDT() async {
    barangTerpilih.value.clear();
    jldtSelected.value.clear();
    barangTerpilih.refresh();
    jldtSelected.refresh();
    Future<List> prosesGetDataSODT = getDataCt.getSpesifikData(
        "JLDT",
        "NOMOR",
        dashboardPenjualanCt.nomorFakturPenjualanSelected.value,
        "get_spesifik_data_transaksi");
    List hasilData = await prosesGetDataSODT;
    if (hasilData.isNotEmpty) {
      jldtSelected.value = hasilData;
      jldtSelected.refresh();
      List groupKodeBarang = [];
      for (var element in hasilData) {
        var data = {
          'GROUP': element['GROUP'],
          'KODE': element['BARANG'],
          'NOURUT': element['NOURUT'],
          'qty_beli': element['QTY'],
          'DISC1': element['DISC1'],
          'DISCD': element['DISCD'],
        };
        groupKodeBarang.add(data);
      }
      if (groupKodeBarang.isNotEmpty) {
        var tampung = [];
        for (var element in listBarang) {
          for (var element1 in groupKodeBarang) {
            if ("${element['GROUP']}${element['KODE']}" ==
                "${element1['GROUP']}${element1['KODE']}") {
              var data = {
                "GROUP": element["GROUP"],
                "KODE": element["KODE"],
                "NOURUT": element1["NOURUT"],
                "INISIAL": element["INISIAL"],
                "INGROUP": element["INGROUP"],
                "NAMA": element["NAMA"],
                "BARCODE": element["BARCODE"],
                "TIPE": element["TIPE"],
                "SAT": element["SAT"],
                "STDJUAL": element["STDJUAL"],
                "qty_beli": element1["qty_beli"],
                "DISC1": element1["DISC1"],
                "DISCD": element1["DISCD"],
              };
              tampung.add(data);
            }
          }
        }
        tampung = tampung.toSet().toList();
        print('tampung data $tampung');
        barangTerpilih.value = tampung;
        barangTerpilih.refresh();
        Future<bool> prosesHitungMenyeluruh = perhitunganMenyeluruh();
        bool hasilProsesHitung = await prosesHitungMenyeluruh;
        if (hasilProsesHitung) statusJLDTKosong.value = false;
        // hitungSubtotal();
      }
    } else {
      var dataUpdate = {
        'column1': 'NOMOR',
        'cari1': dashboardPenjualanCt.nomorFakturPenjualanSelected.value,
        'HRGTOT': '0',
        'DISCD': '0',
        'DISCH': '0',
        'DISCN': '0',
        'BIAYA': '0',
        'TAXN': '0',
        'HRGNET': '0',
        'QTY': '0',
        'QTZ': '0',
      };
      Future<List> prosesUpdateJLHD = GetDataController().editDataGlobal(
          "JLHD", "edit_data_global_transaksi", "1", dataUpdate);
      List hasilproses = await prosesUpdateJLHD;
      print(hasilproses);

      subtotal.value = 0.0;
      subtotal.refresh();

      totalNetto.value = 0.0;
      totalNetto.refresh();

      hrgtotSohd.value = 0.0;
      hrgtotSohd.refresh();

      allQtyBeli.value = 0.0;
      allQtyBeli.refresh();
      UtilsAlert.showToast("Tidak ada item yang terpilih");
      statusJLDTKosong.value = true;
    }
  }

  Future<bool> perhitunganMenyeluruh() async {
    if (jldtSelected.isNotEmpty) {
      Future<List> updateInformasiJLHD = GetDataController().getSpesifikData(
          "JLHD",
          "NOMOR",
          dashboardPenjualanCt.nomorFakturPenjualanSelected.value,
          "get_spesifik_data_transaksi");
      List infoJLHD = await updateInformasiJLHD;

      print("jlhd selected $infoJLHD");

      // perhitungan HRGTOT
      double subtotalKeranjang = 0.0;
      double discdHeader = 0.0;
      double dischHeader = 0.0;
      double allQty = 0.0;

      for (var element in jldtSelected) {
        double hargaBarang = double.parse("${element['HARGA']}");
        double persenDiskonBarang = double.parse("${element['DISC1']}");
        double qtyBarang = double.parse("${element['QTY']}");

        var hitungSubtotal = qtyBarang *
            (hargaBarang - (hargaBarang * persenDiskonBarang * 0.01));

        subtotalKeranjang += hitungSubtotal;

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

        GetDataController().updateJldt(
            "${element['PK']}", "${element['NOURUT']}", valueFinalDiscnJldt);

        double qtyJLDT = double.parse("${element["QTY"]}");
        print('qty dodt $qtyJLDT');
        print('taxn dodt ${element['TAXN']}');
        print('biaya dodt ${element['BIAYA']}');

        GetDataController().updateProd3(
            "${element["NOMOR"]}",
            "${element["NOURUT"]}",
            qtyJLDT,
            valueFinalDiscnJldt,
            double.parse("${element["TAXN"]}"),
            double.parse("${element["BIAYA"]}"));
      }

      // hitung subtotal
      subtotal.value = "$subtotalKeranjang" == "NaN" ? 0 : subtotalKeranjang;
      // subtotal.value = subtotalKeranjang;
      subtotal.refresh();
      print('hasil subtotal ${subtotal.value}');

      // all qty
      allQtyBeli.value = allQty;
      allQtyBeli.refresh();

      // diskon header

      var fltr1 = Utility.persenDiskonHeader(
          "${subtotal.value}", "${infoJLHD[0]["DISCH"]}");

      print('diskon header persen $fltr1');

      persenDiskonHeaderRincian.value.text =
          "$fltr1" == "NaN" ? "0.0" : "$fltr1";
      persenDiskonHeaderRincianView.value.text =
          "$fltr1" == "NaN" ? "0.0" : "$fltr1";
      persenDiskonHeaderRincian.refresh();
      persenDiskonHeaderRincianView.refresh();

      nominalDiskonHeaderRincian.value.text = "${infoJLHD[0]["DISCH"]}";
      nominalDiskonHeaderRincianView.value.text =
          infoJLHD[0]["DISCH"].toStringAsFixed(0);
      nominalDiskonHeaderRincian.refresh();
      nominalDiskonHeaderRincianView.refresh();

      // ppn header

      double taxpJLHD = infoJLHD[0]["TAXP"] == null || infoJLHD[0]["TAXP"] == 0
          ? 0.0
          : infoJLHD[0]["TAXP"].toDouble();

      if (taxpJLHD > 0.0) {
        print('perhitungan ppn header jalan disini');
        persenPPNHeaderRincian.value.text = "$taxpJLHD";
        persenPPNHeaderRincianView.value.text = "$taxpJLHD";
        persenPPNHeaderRincian.refresh();
        persenPPNHeaderRincianView.refresh();

        var convert1PPN = Utility.nominalPPNHeaderView(
            '${subtotal.value}',
            persenDiskonHeaderRincian.value.text,
            persenPPNHeaderRincian.value.text);

        nominalPPNHeaderRincian.value.text = convert1PPN.toString();
        nominalPPNHeaderRincianView.value.text =
            Utility.rupiahFormat("$convert1PPN", "");
        nominalPPNHeaderRincian.refresh();
        nominalPPNHeaderRincianView.refresh();
      } else {
        persenPPNHeaderRincian.value.text = sidebarCt.ppnDefaultCabang.value;
        persenPPNHeaderRincianView.value.text =
            sidebarCt.ppnDefaultCabang.value;
        persenPPNHeaderRincian.refresh();
        persenPPNHeaderRincianView.refresh();

        var convert1PPN = Utility.nominalPPNHeaderView(
            '${subtotal.value}',
            persenDiskonHeaderRincian.value.text,
            persenPPNHeaderRincian.value.text);

        nominalPPNHeaderRincian.value.text = convert1PPN.toString();
        nominalPPNHeaderRincianView.value.text =
            Utility.rupiahFormat("$convert1PPN", "");
        nominalPPNHeaderRincian.refresh();
        nominalPPNHeaderRincianView.refresh();
      }

      // biaya header

      // var convert1 = Utility.persenDiskonHeader(
      //     "${subtotal.value}", "${infoJLHD[0]["BIAYA"]}");

      // var persenBiaya = "$convert1" == "NaN" ? 0 : "$convert1";

      // var convert1Charge = Utility.nominalPPNHeaderView('${subtotal.value}',
      //     persenDiskonHeaderRincian.value.text, "$persenBiaya");

      nominalOngkosHeaderRincian.value.text = "${infoJLHD[0]["BIAYA"]}";
      nominalOngkosHeaderRincianView.value.text =
          Utility.rupiahFormat("${infoJLHD[0]["BIAYA"]}", "");

      totalNetto.value = double.parse("${infoJLHD[0]["HRGNET"]}");
      totalNetto.refresh();

      double discnHeader = discdHeader + dischHeader;

      GetDataController().updateJlhd("${infoJLHD[0]['PK']}", "${allQty}",
          "$discdHeader", "$dischHeader", "$discnHeader");

      // CHECKING PUTANG

      Future<List> checkingPutang = GetDataController().getSpesifikData(
          "PUTANG",
          "NOMOR",
          "${infoJLHD[0]['NOMOR']}",
          "get_spesifik_data_transaksi");
      List prosesCheckPutang = await checkingPutang;

      if (prosesCheckPutang.isEmpty) {
        var dataInsert = [
          dashboardPenjualanCt.selectedIdSales.value,
          dashboardPenjualanCt.selectedIdPelanggan.value,
          dashboardPenjualanCt.wilayahCustomerSelected.value,
          "${infoJLHD[0]['NOMOR']}",
          "${infoJLHD[0]['NOMORCB']}",
          "${infoJLHD[0]['NOMOR']}",
          sidebarCt.cabangKodeSelectedSide.value,
          totalNetto.value,
          0,
          totalNetto.value,
        ];

        GetDataController().insertPutang(dataInsert);
      } else {
        var dataUpdate = {
          'column1': 'NOMOR',
          'cari1': "${infoJLHD[0]['NOMOR']}",
          'DEBE': totalNetto.value,
          'SALDO': totalNetto.value,
        };
        Future<List> prosesUpdateJLHD = GetDataController().editDataGlobal(
            "PUTANG", "edit_data_global_transaksi", "1", dataUpdate);
        List hasilproses = await prosesUpdateJLHD;
        print('hasil update putang $hasilproses');
      }

      perhitunganHeader();
    }
    return Future.value(true);
  }

  void perhitunganHeader() {
    // setting header
    double convertDiskon =
        Utility.validasiValueDouble(nominalDiskonHeaderRincian.value.text);
    double ppnPPN =
        Utility.validasiValueDouble(persenPPNHeaderRincian.value.text);
    double convertPPN =
        Utility.validasiValueDouble(nominalPPNHeaderRincian.value.text);
    double convertBiaya =
        Utility.validasiValueDouble(nominalOngkosHeaderRincian.value.text);

    print("subtotal ${subtotal.value}");
    print("diskon header $convertDiskon");
    print("ppn header $convertPPN");
    print("biaya header $convertBiaya");

    GetDataController().hitungHeader(
        "JLHD",
        "JLDT",
        dashboardPenjualanCt.nomorFakturPenjualanSelected.value,
        "${subtotal.value}",
        "$convertDiskon",
        "$ppnPPN",
        "$convertPPN",
        "$convertBiaya");

    persenDiskonHeaderRincian.refresh();
    nominalDiskonHeaderRincian.refresh();
    persenDiskonHeaderRincianView.refresh();
    nominalDiskonHeaderRincianView.refresh();

    persenPPNHeaderRincian.refresh();
    nominalPPNHeaderRincian.refresh();
    persenPPNHeaderRincianView.refresh();
    nominalPPNHeaderRincianView.refresh();

    nominalOngkosHeaderRincian.refresh();
    nominalOngkosHeaderRincianView.refresh();
  }

  void showDialog() {
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
            child: ModalPopupPeringatan(
              title: "Order Penjualan",
              content: "Yakin simpan data ini ?",
              positiveBtnText: "Simpan",
              negativeBtnText: "Urungkan",
              positiveBtnPressed: () {
                backValidasi();
              },
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  void backValidasi() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Loading...");
    Future<bool> prosesClose = getDataCt.closePenjualan("JLHD", "",
        dashboardPenjualanCt.nomorFakturPenjualanSelected.value, "close_jlhd");
    bool hasilClose = await prosesClose;
    if (hasilClose == true) {
      dashboardPenjualanCt.getDataFakturPenjualan();
      if (statusAksiItemFakturPenjualan.value) {
        Get.back();
        Get.back();
        Get.back();
        statusBack.value = true;
        statusBack.refresh();
      } else {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        statusBack.value = true;
        statusBack.refresh();
      }
    }
  }

  void editBarangSelected(group, kode) {
    List editData = barangTerpilih.value
        .where((element) =>
            "${element['GROUP']}${element['KODE']}" == "$group$kode")
        .toList();
    if (editData.isNotEmpty) {
      statusEditBarang.value = true;
      typeAksi.value = "edit_barang";
      typeAksi.refresh();
      FPSIButtomSheetPesanBarang().prosesPesanBarang1(editData);
    } else {
      UtilsAlert.showToast("Gagal edit data");
    }
  }

  void hapusJLDT(nourut) {
    ButtonSheetController().validasiButtonSheet(
        "Hapus Barang", contentOpHapusBarang(), "op_hapus_barang", 'Hapus',
        () async {
      UtilsAlert.loadingSimpanData(Get.context!, "Hapus data...");
      Future<bool> prosesHapusSODT = getDataCt.hapusSODT(
          dashboardPenjualanCt.nomorSoSelected.value, nourut);
      bool hasilHapus = await prosesHapusSODT;
      if (hasilHapus) {
        loadDataJLDT();
        Get.back();
        Get.back();
        UtilsAlert.showToast("Berhasil hapus barang");
      }
    });
  }

  void showKeteranganJLHD() async {
    // print(dashboardPenjualanCt.fakturPenjualanSelected);
    Future<List> updateInformasiJLHD = GetDataController().getSpesifikData(
        "JLHD",
        "NOMOR",
        dashboardPenjualanCt.fakturPenjualanSelected[0]["NOMOR"],
        "get_spesifik_data_transaksi");
    List infoJLHD = await updateInformasiJLHD;

    keterangan1.value.text = infoJLHD[0]['KET1'] ?? "";
    keterangan2.value.text = infoJLHD[0]['KET2'] ?? "";
    keterangan3.value.text = infoJLHD[0]['KET3'] ?? "";
    keterangan4.value.text = infoJLHD[0]['KET4'] ?? "";
    ButtonSheetController().validasiButtonSheet(
        "Keterangan", contentShowKeterangan(), "show_keterangan", "", () => {});
  }

  Widget contentShowKeterangan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Keterangan 1",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan1.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.normal,
        ),
        Text(
          "Keterangan 2",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan2.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.normal,
        ),
        Text(
          "Keterangan 3",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan3.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.normal,
        ),
        Text(
          "Keterangan 4",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan4.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.medium,
        ),
        InkWell(
          onTap: () => simpanPerubahanKeterangan(),
          child: CardCustom(
            colorBg: Utility.primaryDefault,
            radiusBorder: Utility.borderStyle1,
            widgetCardCustom: Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  "Simpan perubahan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void simpanPerubahanKeterangan() {
    ButtonSheetController().validasiButtonSheet(
        "Keterangan",
        Text("Yakin simpan perubahan keterangan ?"),
        "perubahan_keterangan",
        "Simpan", () async {
      UtilsAlert.loadingSimpanData(Get.context!, "Simpan perubahan data...");
      var dataUpdate = {
        'column1': 'NOMOR',
        'cari1': '${dashboardPenjualanCt.nomorSoSelected.value}',
        'KET1': keterangan1.value.text,
        'KET2': keterangan2.value.text,
        'KET3': keterangan3.value.text,
        'KET4': keterangan4.value.text,
      };
      print('edit keterangan sampe sini');
      Future<List> editKeterangan = GetDataController().editDataGlobal(
          "SOHD", "edit_data_global_transaksi", "1", dataUpdate);
      List hasilUpdate = await editKeterangan;
      if (hasilUpdate[0] == true) {
        Future<bool> prosesRefreshSOHD = dashboardPenjualanCt.getDataAllSOHD();
        bool hasilProsesRefresh = await prosesRefreshSOHD;
        if (hasilProsesRefresh == true) {
          dashboardPenjualanCt.loadSOHDSelected();
          Get.back();
          Get.back();
          Get.back();
        }
      }
    });
  }

  Widget contentOpHapusBarang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Apa kamu yakin hapus barang ini ?",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: Utility.medium, color: Utility.greyDark),
        )
      ],
    );
  }
}
