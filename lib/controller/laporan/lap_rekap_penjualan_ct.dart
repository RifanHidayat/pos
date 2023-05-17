import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/buttom_sheet_global.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/model/laporan/list_rekap_penjualan_model.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/text_form_field_group.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

import '../../utils/api.dart';
import '../pos/dashboard_controller.dart';

class LaporanRekapPenjualanController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  RefreshController refreshDetailController =
      RefreshController(initialRefresh: true);
  var dashbardController = Get.put(DashbardController());

  var sidebarCt = Get.put(SidebarController());

  var screenLoad = false.obs;
  var bestSellerView = true.obs;

  var listRekapPenjualan = <ListRekapPenjualanModel>[].obs;
  var detailRekap = [].obs;
  var dataBarang = [].obs;
  var dataPelanggan = [].obs;
  var dataSales = [].obs;
  var dataBarangFilter = [].obs;

  var statusFilter = "".obs;
  var tanggalDari = "".obs;
  var tanggalSampai = "".obs;

  // PELANGGAN
  var kodePelangganSelected = "".obs;
  var namaPelangganSelected = "".obs;

  // SALES
  var kodeSalesSelected = "".obs;
  var namaSalesSelected = "".obs;

  // BARANG FILTER
  var kodeBarangfSelected = "".obs;
  var groupBarangSelected = "".obs;
  var namaBarangSelected = "".obs;

  var statusMember = 0.obs;
  var screenDetailAktif = 0.obs;
  var filterAktif = 0.obs;

  var dummyData = [
    {"title": "SI2022010001", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010002", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010003", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010004", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010005", "jumlah": "25", "total": "50000000"},
  ];

  var dummyDataPelanggan = [
    {"NAMA": "Pelanggan 1", "ALAMAT": "Alamat 1"},
    {"NAMA": "Pelanggan 2", "ALAMAT": "Alamat 2"},
    {"NAMA": "Pelanggan 3", "ALAMAT": "Alamat 3"},
    {"NAMA": "Pelanggan 4", "ALAMAT": "Alamat 4"},
    {"NAMA": "Pelanggan 5", "ALAMAT": "Alamat 5"},
  ];

  var dummyDataSales = [
    {"NAMA": "Sales 1", "ALAMAT": "Alamat 1"},
    {"NAMA": "Sales 2", "ALAMAT": "Alamat 2"},
    {"NAMA": "Sales 3", "ALAMAT": "Alamat 3"},
    {"NAMA": "Sales 4", "ALAMAT": "Alamat 4"},
    {"NAMA": "Sales 5", "ALAMAT": "Alamat 5"},
  ];

  var dummyDataBarangFilter = [
    {"NAMA": "Barang 1"},
    {"NAMA": "Barang 2"},
    {"NAMA": "Barang 3"},
    {"NAMA": "Barang 4"},
    {"NAMA": "Barang 5"},
  ];

  var dummyDataBarang = [
    {
      "nama": "Nama Barang",
      "jumlah": "25",
      "satuan": "PCS",
      "harga_jual": "500000"
    },
    {
      "nama": "Nama Barang",
      "jumlah": "25",
      "satuan": "PCS",
      "harga_jual": "500000"
    },
    {
      "nama": "Nama Barang",
      "jumlah": "25",
      "satuan": "PCS",
      "harga_jual": "500000"
    },
    {
      "nama": "Nama Barang",
      "jumlah": "25",
      "satuan": "PCS",
      "harga_jual": "500000"
    },
    {
      "nama": "Nama Barang",
      "jumlah": "25",
      "satuan": "PCS",
      "harga_jual": "500000"
    },
  ];

  void startLoad() {
    getProsesListRekap();
    getProsesPelanggan();
    getProsesSales();
    getProsesBarang();
    tanggalDari.value = Utility.convertDate1("${sidebarCt.dateTimeNow.value}");
    tanggalSampai.value =
        Utility.convertDate1("${sidebarCt.dateTimeNow.value}");
    tanggalDari.refresh();
    tanggalSampai.refresh();
  }

  Future<bool> getProsesListRekap() async {
    var connect = Api.connectionApi2("get", "", "penjualan/report",
        "&cabang=${sidebarCt.cabangKodeSelectedSide.value}&kode_sales=${dashbardController.kodePelayanSelected}");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    debugPrint('Convert ${data}');
    for (var element in data) {
      listRekapPenjualan.add(ListRekapPenjualanModel(
        title: element["NOMOR"],
        jumlah: element["PK"].toString(),
        total: element["NETTO"].toString(),
      ));
    }
    listRekapPenjualan.refresh();

    for (var element in dummyDataBarang) {
      dataBarang.add(element);
    }
    dataBarang.refresh();

    return Future.value(true);
  }

  Future<bool> getProsesPelanggan() {
    for (var element in dummyDataPelanggan) {
      dataPelanggan.add(element);
    }
    dataPelanggan.refresh();
    return Future.value(true);
  }

  Future<bool> getProsesSales() {
    for (var element in dummyDataSales) {
      dataSales.add(element);
    }
    dataSales.refresh();
    return Future.value(true);
  }

  Future<bool> getProsesBarang() {
    for (var element in dummyDataBarangFilter) {
      dataBarangFilter.add(element);
    }
    dataBarangFilter.refresh();
    return Future.value(true);
  }

  void detailBarang() {
    print(dataBarang);
    ButtonSheetController().validasiButtonSheet(
        "Nomor PO", listKontenBarang(), "show_keterangan", "", () {});
  }

  Widget listKontenBarang() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: dataBarang.length,
        itemBuilder: (context, index) {
          var nama = dataBarang[index]['nama'];
          var jumlah = dataBarang[index]['jumlah'];
          var satuan = dataBarang[index]['satuan'];
          var harga = dataBarang[index]['harga_jual'];
          var total = Utility.validasiValueDouble(jumlah!) *
              Utility.validasiValueDouble(harga!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$nama",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$jumlah X ${Utility.rupiahFormat('$harga', '')}",
                            style: TextStyle(color: Utility.nonAktif),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 40,
                        child: Center(
                          child: Text(
                            "${Utility.rupiahFormat('$total', 'with_rp')}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ),
              Divider()
            ],
          );
        });
  }

  void filterTanggal() {
    ButtonSheetController().validasiButtonSheet(
        "Filter Tanggal", kontenFilterTanggal(), "", "Filter", () {});
  }

  Widget kontenFilterTanggal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLabel(
                  text: "Tanggal Dari",
                ),
                SizedBox(
                  height: 3,
                ),
                TextFieldDate(
                  tanggal: "${tanggalDari.value}",
                  onTap: (valueDate) {
                    print(valueDate);
                  },
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLabel(
                  text: "Tanggal Sampai",
                ),
                SizedBox(
                  height: 3,
                ),
                TextFieldDate(
                  tanggal: "${tanggalSampai.value}",
                  onTap: (valueDate) {
                    print(valueDate);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void filterPelanggan() {
    GlobalBottomSheet().buttomSheetGlobal(dataPelanggan, "Filter Pelanggan",
        "filter_pelanggan_rekap_penjualan", namaPelangganSelected.value);
  }

  void filterSales() {
    GlobalBottomSheet().buttomSheetGlobal(dataSales, "Filter Sales",
        "filter_sales_rekap_penjualan", namaSalesSelected.value);
  }

  void filterBarang() {
    GlobalBottomSheet().buttomSheetGlobal(dataBarangFilter, "Filter Barang",
        "filter_barang_rekap_penjualan", namaBarangSelected.value);
  }
}
