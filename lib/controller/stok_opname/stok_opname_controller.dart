import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/model/detail_barang.dart';
import 'package:siscom_pos/model/stok_opname/list_stok_opname.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/request.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/text_form_field_group.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class StockOpnameController extends GetxController {
  var listStokOpname = <ListStokOpnameModel>[].obs;

  var screenLoad = false.obs;

  List dummyData = [
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    }
  ];

  List dataDetailBarangStokOpname = [
    {"nama": "APPLE IPHONE 13 PRO MAX PROMAX 128GB", "stok": 50},
    {"nama": "APPLE IPHONE 13 PRO MAX PROMAX 128GB", "stok": 50},
    {"nama": "APPLE IPHONE 13 PRO MAX PROMAX 128GB", "stok": 50},
    {"nama": "APPLE IPHONE 13 PRO MAX PROMAX 128GB", "stok": 50},
    {"nama": "APPLE IPHONE 13 PRO MAX PROMAX 128GB", "stok": 50},
  ];

  var isLoading = true.obs;
  var barangDetailStokOpname = [].obs;
  var barangs = <DetailBarangModel>[].obs;

  var pencarian = TextEditingController().obs;
  var tanggal = TextEditingController().obs;
  var tanggalBuatStok = TextEditingController().obs;
  var diopnameOleh = TextEditingController().obs;
  var fisikStokDetail = TextEditingController().obs;

  var tahun = "".obs;
  var bulan = "".obs;
  var bulanString = "".obs;

  var gudangCodeSelected = "".obs;

  var groupCodeSelected = "".obs;

  void startLoad() {
    getListStokOpname();
  }

  Future<bool> getListStokOpname() async {
    // dummy data
    for (var element in dummyData) {
      listStokOpname.add(ListStokOpnameModel(
        nomorFaktur: element["nomor_faktur"],
        kodeCabang: element["kode_cabang"],
        namaCabang: element["nama_cabang"],
        kodeGudang: element["kode_gudang"],
        namaGudang: element["nama_gudang"],
        tanggal: element["tanggal"],
      ));
    }
    listStokOpname.refresh();

    // form api
    // Future<List> prosesDataStokOpname = ApiStokOpname().getListStokOpname();
    // List hasilData = await prosesDataStokOpname;

    return Future.value(true);
  }

  void resetData() {
    gudangCodeSelected.value = "";
  }

  void detailPenyesuaianBarangStokOpname() {
    ButtonSheetController().validasiButtonSheet(
        "", contentPenyesuaianStokOpname(), "", "Simpan", () {});
  }

  Widget contentPenyesuaianStokOpname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabel(
          text: "APPLE IPHONE 13 PRO MAX PROMAX 128GB",
          weigh: FontWeight.bold,
        ),
        TextLabel(text: "002 - GUDANG BAHAN BAKU"),
        SizedBox(
          height: Utility.medium,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: CardCustom(
                  colorBg: Utility.baseColor2,
                  radiusBorder: Utility.borderStyle1,
                  widgetCardCustom: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(
                          text: "Gudang",
                          size: Utility.small,
                          color: Utility.nonAktif,
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        TextLabel(
                          text: "Nama Gudang",
                          weigh: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: CardCustom(
                  colorBg: Utility.baseColor2,
                  radiusBorder: Utility.borderStyle1,
                  widgetCardCustom: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(
                          text: "Stok",
                          size: Utility.small,
                          color: Utility.nonAktif,
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        TextLabel(
                          text: "1200",
                          weigh: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: Utility.medium,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: CardCustom(
                  colorBg: Utility.baseColor2,
                  radiusBorder: Utility.borderStyle1,
                  widgetCardCustom: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(
                          text: "Fisik",
                          size: Utility.small,
                          color: Utility.nonAktif,
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        SizedBox(
                          height: 18,
                          child: TextField(
                            cursorColor: Utility.primaryDefault,
                            controller: fisikStokDetail.value,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                fontSize: 14.0,
                                height: 1.5,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: CardCustom(
                  colorBg: Utility.baseColor2,
                  radiusBorder: Utility.borderStyle1,
                  widgetCardCustom: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(
                          text: "Selisih",
                          size: Utility.small,
                          color: Utility.nonAktif,
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        TextLabel(
                          text: "10",
                          weigh: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: Utility.medium,
        ),
      ],
    );
  }
}
