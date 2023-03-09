import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/model/laporan/list_rekap_penjualan_model.dart';
import 'package:siscom_pos/utils/utility.dart';

class LaporanRekapPenjualanController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  RefreshController refreshDetailController =
      RefreshController(initialRefresh: true);

  var screenLoad = false.obs;
  var bestSellerView = true.obs;

  var listRekapPenjualan = <ListRekapPenjualanModel>[].obs;
  var detailRekap = [].obs;
  var dataBarang = [].obs;

  var statusFilter = "".obs;

  var statusMember = 0.obs;
  var screenDetailAktif = 0.obs;

  var dummyData = [
    {"title": "SI2022010001", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010002", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010003", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010004", "jumlah": "25", "total": "50000000"},
    {"title": "SI2022010005", "jumlah": "25", "total": "50000000"},
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
  }

  Future<bool> getProsesListRekap() {
    for (var element in dummyData) {
      listRekapPenjualan.add(ListRekapPenjualanModel(
        title: element["title"],
        jumlah: element["jumlah"],
        total: element["total"],
      ));
    }
    listRekapPenjualan.refresh();

    for (var element in dummyDataBarang) {
      dataBarang.add(element);
    }
    dataBarang.refresh();

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
}
