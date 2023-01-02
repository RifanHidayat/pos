import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/buttom_sheet/op_pesan_barang_ct.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class ItemOrderPenjualanController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var getDataCt = Get.put(GetDataController());
  var sidebarCt = Get.put(SidebarController());

  var jumlahPesan = TextEditingController().obs;
  var hargaJualPesanBarang = TextEditingController().obs;

  var persenDiskonPesanBarang = TextEditingController().obs;
  var nominalDiskonPesanBarang = TextEditingController().obs;

  var persenDiskonHeaderRincian = TextEditingController().obs;
  var nominalDiskonHeaderRincian = TextEditingController().obs;

  var persenPPNHeaderRincian = TextEditingController().obs;
  var nominalPPNHeaderRincian = TextEditingController().obs;

  var nominalOngkosHeaderRincian = TextEditingController().obs;

  Rx<List<String>> typeBarang = Rx<List<String>>([]);

  var listBarang = [].obs;
  var barangTerpilih = [].obs;
  var sodtSelected = [].obs;

  var statusBack = false.obs;
  var statusInformasiSo = false.obs;
  var statusEditBarang = false.obs;
  var statusAksiItemOrderPenjualan = false.obs;
  var statusSODTKosong = false.obs;

  var totalPesanBarang = 0.0.obs;
  var totalNetto = 0.0.obs;
  var hrgtotSohd = 0.0.obs;
  var subtotal = 0.0.obs;
  var allQtyBeli = 0.0.obs;

  var typeFocus = "".obs;
  var typeBarangSelected = "".obs;
  var htgBarangSelected = "".obs;
  var pakBarangSelected = "".obs;

  void getDataBarang(status) async {
    listBarang.value.clear();
    barangTerpilih.value.clear();
    sodtSelected.value.clear();
    listBarang.refresh();
    barangTerpilih.refresh();
    sodtSelected.refresh();
    statusAksiItemOrderPenjualan.value = status;
    statusAksiItemOrderPenjualan.refresh();
    Future<List> prosesGetDataBarang = getDataCt.getAllBarang();
    List data = await prosesGetDataBarang;
    if (data.isNotEmpty) {
      listBarang.value = data;
      listBarang.refresh();
      if (status == true) {
        loadDataSODT();
      } else {
        statusSODTKosong.value = true;
        statusSODTKosong.refresh();
      }
    }
  }

  void loadDataSODT() async {
    barangTerpilih.value.clear();
    sodtSelected.value.clear();
    barangTerpilih.refresh();
    sodtSelected.refresh();
    Future<List> prosesGetDataSODT = getDataCt.getSpesifikData(
        "SODT",
        "NOMOR",
        dashboardPenjualanCt.nomorSoSelected.value,
        "get_spesifik_data_transaksi");
    List hasilData = await prosesGetDataSODT;
    if (hasilData.isNotEmpty) {
      sodtSelected.value = hasilData;
      sodtSelected.refresh();
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
        barangTerpilih.value = tampung;
        barangTerpilih.refresh();
        Future<bool> prosesHitungMenyeluruh =
            OrderPenjualanPesanBarangController()
                .perhitunganMenyeluruhOrderPenjualan(sodtSelected);
        bool hasilProsesHitung = await prosesHitungMenyeluruh;
        if (hasilProsesHitung) statusSODTKosong.value = false;
        // hitungSubtotal();
      }
    } else {
      UtilsAlert.showToast("Tidak ada item yang terpilih");
      statusSODTKosong.value = true;
    }
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
    Future<bool> prosesClose =
        getDataCt.closeSODH("", dashboardPenjualanCt.nomorSoSelected.value);
    bool hasilClose = await prosesClose;
    if (hasilClose == true) {
      dashboardPenjualanCt.getDataAllSOHD();
      if (statusAksiItemOrderPenjualan.value) {
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
      OrderPenjualanPesanBarangController().validasiEditBarang(editData);
    } else {
      UtilsAlert.showToast("Gagal edit data");
    }
  }

  void hapusSODT(nourut) {
    ButtonSheetController().validasiButtonSheet(
        "Hapus Barang", contentOpHapusBarang(), "op_hapus_barang", 'Hapus',
        () async {
      UtilsAlert.loadingSimpanData(Get.context!, "Hapus data...");
      Future<bool> prosesHapusSODT = getDataCt.hapusSODT(
          dashboardPenjualanCt.nomorSoSelected.value, nourut);
      bool hasilHapus = await prosesHapusSODT;
      if (hasilHapus) {
        loadDataSODT();
        Get.back();
        Get.back();
        UtilsAlert.showToast("Berhasil hapus barang");
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
