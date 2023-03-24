import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/model/detail_barang.dart';
import 'package:siscom_pos/model/stok_opname/list_stok_opname.dart';
import 'package:siscom_pos/model/stok_opname/tambah_opnamedt.dart';
import 'package:siscom_pos/screen/stockopname/detail_barang_stok_opname.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/request.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/text_form_field_group.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class StockOpnameController extends GetxController {
  var sidebarCt = Get.put(SidebarController());

  RefreshController refreshController = RefreshController(initialRefresh: true);
  var listStokOpname = <ListStokOpnameModel>[].obs;
  var listStokOpnameMaster = <ListStokOpnameModel>[].obs;
  var listAllGudang = [].obs;
  var listAllKelompokBarang = [].obs;
  var detailBarangTambahStokOpnameDt = <TambahOpnameDt>[].obs;
  var detailBarangTambahStokOpnameDtMaster = <TambahOpnameDt>[].obs;

  var screenLoad = false.obs;

  var isLoading = true.obs;
  var barangDetailStokOpname = [].obs;
  var barangs = <DetailBarangModel>[].obs;

  var pencarian = TextEditingController().obs;
  var tanggal = TextEditingController().obs;
  var tanggalBuatStok = TextEditingController().obs;
  var diopnameOleh = TextEditingController().obs;
  var fisikStokDetail = TextEditingController().obs;

  var page = 10.obs;

  var tahun = "".obs;
  var bulan = "".obs;
  var bulanString = "".obs;

  // TAMBAH STOK OPNAME
  var kodeTambahHd = "".obs;
  var kodeGudangSelected = "".obs;
  var namaGudangSelected = "".obs;
  var kodeKelompokBarang = "".obs;
  var inisialKelompokBarang = "".obs;
  var namaKelompokBarang = "".obs;
  var kodeHeader = "".obs;
  var nomorHeader = "".obs;

  var totalStok = 0.obs;
  var totalFisik = 0.obs;

  var gudangCodeSelected = "".obs;

  var groupCodeSelected = "".obs;

  void startLoad() {
    getTime();
    getListStokOpname();
  }

  void getTime() {
    var dt = DateTime.now();
    tanggalBuatStok.value.text = "${DateFormat('yyyy-MM-dd').format(dt)}";
  }

  Future<bool> getListStokOpname() async {
    var connect = Api.connectionApi2("get", "", "stok-opname-hd",
        "&cabang=${sidebarCt.cabangKodeSelectedSide.value}");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      for (var element in data) {
        List<ListStokOpnameModel> tampungStokOpname = [];
        for (var element in data) {
          tampungStokOpname.add(ListStokOpnameModel(
            nomorFaktur: element["NOMOR"],
            kodeCabang: element["CB"],
            namaCabang: element["NAMA_CABANG"],
            kodeGudang: element["GUDANG"],
            namaGudang: element["NAMA_GUDANG"],
            kelompokBarang: "",
            diopnameOleh: "",
            tanggal: element["TANGGAL"],
          ));
        }
        listStokOpname.value = tampungStokOpname;
        listStokOpnameMaster.value = tampungStokOpname;
        listStokOpname.refresh();
        listStokOpnameMaster.refresh();
      }
    }

    screenLoad.value = true;
    screenLoad.refresh();

    return Future.value(true);
  }

  void resetData() {
    gudangCodeSelected.value = "";
  }

  void getLastKodeStokOpname() async {
    Future<List> checkLastStokOpname =
        GetDataController().checkLastRecord("OPNAMEHD", "NOMOR");
    List hasilLastRecord = await checkLastStokOpname;
    if (hasilLastRecord[0] == true && hasilLastRecord[2].length != 0) {
      // VALIDASI LAST NOMOR

      var lastNomor = hasilLastRecord[2][0]["NOMOR"];
      var hitung1 = int.parse(lastNomor) + 1;
      var hitung2 = "$hitung1".length == 1
          ? "0000$hitung1"
          : "$hitung1".length == 2
              ? "000$hitung1"
              : "$hitung1".length == 3
                  ? "0$hitung1"
                  : "$hitung1";
      kodeTambahHd.value = hitung2;
      kodeTambahHd.refresh();

      // GET ALL GUDANG
      var connect = Api.connectionApi2("get", "", "stok-opname-gudang",
          "&cabang=${sidebarCt.cabangKodeSelectedSide.value}");
      var getValue = await connect;
      var valueBody = jsonDecode(getValue.body);
      List dataGudang = valueBody['data'];

      if (dataGudang.isNotEmpty) {
        var getFirst = dataGudang.first;
        kodeGudangSelected.value = getFirst["KODE"];
        namaGudangSelected.value = getFirst["NAMA"];
        kodeGudangSelected.refresh();
        namaGudangSelected.refresh();
        listAllGudang.value = dataGudang;
        listAllGudang.refresh();
      }

      // KELOMPOK BARANG

      var connect2 = Api.connectionApi2("get", "", "stok-opname-group", "");
      var getValue2 = await connect2;
      var valueBody2 = jsonDecode(getValue2.body);
      List dataKelompokBarang = valueBody2['data'];

      if (dataKelompokBarang.isNotEmpty) {
        listAllKelompokBarang.value = dataKelompokBarang;
        kodeKelompokBarang.refresh();
        inisialKelompokBarang.refresh();
        namaKelompokBarang.refresh();
      }

      Get.to(TambahStokOpname());
    }
  }

  void validasiSimpanHeaderStokOpname() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang Memuat...");
    if (tanggalBuatStok.value.text == "" ||
        kodeGudangSelected.value == "" ||
        diopnameOleh.value.text == "") {
      UtilsAlert.showToast("Harap Lengkapi form terlebih dahulu");
      Get.back();
    } else {
      Map<String, dynamic> body = {
        'tanggal': tanggalBuatStok.value.text,
        'gudang': kodeGudangSelected.value,
        'group': kodeKelompokBarang.value,
        'diopname': diopnameOleh.value.text,
        'cabang': sidebarCt.cabangKodeSelectedSide.value
      };
      var connect = Api.connectionApi2("post", body, "stok-opname-hd", "");
      var getValue = await connect;
      var valueBody = jsonDecode(getValue.body);

      if (valueBody["status"] == true) {
        // VALIDASI MASUK KE DETAIL STOK OPNAME
        var idOpnameHD = valueBody["data"]["nomor"];
        beforeEnterDetailStokOpname(idOpnameHD, "tambah");
      } else {
        Get.back();
        UtilsAlert.showToast("Gagal memuat data detail");
      }
    }
  }

  void beforeEnterDetailStokOpname(nomorHd, status) async {
    totalFisik.value = 0;
    totalFisik.refresh();
    totalStok.value = 0;
    totalStok.refresh();
    var connect2 = Api.connectionApi2("get", "", "stok-opname-hd/$nomorHd", "");
    var getValue2 = await connect2;
    var valueBody2 = jsonDecode(getValue2.body);

    // print(valueBody2);

    if (valueBody2["status"] == true) {
      kodeHeader.value = '${valueBody2["data"]["KODE"]}';
      kodeHeader.refresh();
      nomorHeader.value = '${valueBody2["data"]["NOMOR"]}';
      nomorHeader.refresh();
      List dataResponseDetail = valueBody2["data"]["detail"];

      if (dataResponseDetail.isNotEmpty) {
        int hitungStok = 0;
        int hitungFisik = 0;
        List<TambahOpnameDt> tampungDetail = [];
        for (var element in dataResponseDetail) {
          hitungStok += int.parse('${element["STOK"]}');
          hitungFisik += int.parse('${element["FISIK"]}');
          tampungDetail.add(TambahOpnameDt(
            namaBarang: element["NAMA"],
            group: element["GROUP"],
            kodeBarang: element["BARANG"],
            fisik: element["FISIK"],
            qty: element["STOK"],
            diopname: status == "tambah"
                ? diopnameOleh.value.text
                : element["PEMBUAT"],
            tanggal: element["TANGGAL"],
            nomor: element["NOMOR"],
            cabang: element["CB"],
          ));
        }
        totalStok.value = hitungStok;
        totalStok.refresh();
        totalFisik.value = hitungFisik;
        totalFisik.refresh();
        detailBarangTambahStokOpnameDt.value = tampungDetail;
        detailBarangTambahStokOpnameDtMaster.value = tampungDetail;
      }
      Get.back();
      Get.back();
      Get.to(DetailBarangStokOpname(),
          duration: Duration(milliseconds: 300),
          transition: Transition.rightToLeftWithFade);
    } else {
      Get.back();
      UtilsAlert.showToast("Gagal memuat data detail");
    }
  }

  void detailPenyesuaianBarangStokOpname(groupKodeBarang) {
    var getBarangSelected = detailBarangTambahStokOpnameDt
        .firstWhere((el) => "${el.group}${el.kodeBarang}" == groupKodeBarang);

    fisikStokDetail.value.text = "${getBarangSelected.fisik}";
    ButtonSheetController().validasiButtonSheet(
        "",
        contentPenyesuaianStokOpname(getBarangSelected, groupKodeBarang),
        "show_keterangan",
        "", () async {
      // print(nomorHeader.value);
    });
  }

  Widget contentPenyesuaianStokOpname(getBarangSelected, groupKodeBarang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabel(
          text: "${getBarangSelected.namaBarang}",
          weigh: FontWeight.bold,
        ),
        TextLabel(
            text: "${kodeGudangSelected.value} - ${namaGudangSelected.value} "),
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
                          text: namaGudangSelected.value,
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
                          text: "${getBarangSelected.qty}",
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
                          text:
                              "${getBarangSelected.qty - int.parse(fisikStokDetail.value.text)}",
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
          height: Utility.large,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Button3(
                    textBtn: "Hapus",
                    colorSideborder: Utility.primaryDefault,
                    overlayColor: Color.fromARGB(119, 244, 67, 54),
                    colorText: Utility.primaryDefault,
                    onTap: () async {
                      ButtonSheetController().validasiButtonSheet(
                          "Hapus Barang",
                          TextLabel(
                              text:
                                  "Yakin hapus data ${getBarangSelected.namaBarang} ?"),
                          "",
                          "Hapus", () async {
                        UtilsAlert.loadingSimpanData(
                            Get.context!, "Hapus data");
                        Map<String, dynamic> body = {
                          'kode': kodeHeader.value,
                          'gudang': kodeGudangSelected.value,
                          'group': getBarangSelected.group,
                          'barang': getBarangSelected.kodeBarang,
                        };
                        var connect = Api.connectionApi2(
                            "post", body, "stok-opname-dt-delete", "");
                        var getValue = await connect;
                        var valueBody = jsonDecode(getValue.body);
                        if (valueBody["code"] == 200) {
                          detailBarangTambahStokOpnameDt.removeWhere(
                              (element) =>
                                  "${element.group}${element.kodeBarang}" ==
                                  groupKodeBarang);
                          detailBarangTambahStokOpnameDtMaster.removeWhere(
                              (element) =>
                                  "${element.group}${element.kodeBarang}" ==
                                  groupKodeBarang);
                          detailBarangTambahStokOpnameDt.refresh();
                          detailBarangTambahStokOpnameDtMaster.refresh();
                          Future<bool> prosesHitung = hitungStokdanFisik();
                          bool hasilHitung = await prosesHitung;
                          if (hasilHitung) {
                            Get.back();
                            Get.back();
                            Get.back();
                          }
                        } else {
                          UtilsAlert.showToast("Gagal hapus data");
                          Get.back();
                          Get.back();
                        }
                      });
                    },
                  )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: Button1(
                  textBtn: "Simpan",
                  colorBtn: Utility.primaryDefault,
                  colorText: Utility.baseColor2,
                  onTap: () async {
                    UtilsAlert.loadingSimpanData(Get.context!, "Simpan data");
                    Map<String, dynamic> body = {
                      'gudang': kodeGudangSelected.value,
                      'group': getBarangSelected.group,
                      'barang': getBarangSelected.kodeBarang,
                      'fisik': fisikStokDetail.value.text,
                      'kode': kodeHeader.value
                    };
                    var connect =
                        Api.connectionApi2("patch", body, "stok-opname-dt", "");
                    var getValue = await connect;
                    var valueBody = jsonDecode(getValue.body);
                    if (valueBody["code"] == 200) {
                      var barangMaster = detailBarangTambahStokOpnameDtMaster
                          .firstWhere((el) =>
                              "${el.group}${el.kodeBarang}" == groupKodeBarang);
                      barangMaster.fisik =
                          int.parse(fisikStokDetail.value.text);
                      detailBarangTambahStokOpnameDt.refresh();
                      detailBarangTambahStokOpnameDtMaster.refresh();
                      Future<bool> prosesHitung = hitungStokdanFisik();
                      bool hasilHitung = await prosesHitung;
                      if (hasilHitung) {
                        Get.back();
                        Get.back();
                      }
                    } else {
                      Get.back();
                      UtilsAlert.showToast("Gagal Simpan data");
                    }
                  },
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Future<bool> hitungStokdanFisik() {
    int hasilQty = 0;
    int hasilFisik = 0;
    for (var element in detailBarangTambahStokOpnameDtMaster) {
      hasilQty += int.parse("${element.qty}");
      hasilFisik += int.parse("${element.fisik}");
    }
    totalStok.value = hasilQty;
    totalFisik.value = hasilFisik;
    return Future.value(true);
  }

  void hapusListStopOpname(nomorFaktur) {
    ButtonSheetController().validasiButtonSheet(
        "Hapus Barang",
        TextLabel(text: "Yakin hapus data $nomorFaktur ?"),
        "",
        "Hapus", () async {
      UtilsAlert.loadingSimpanData(Get.context!, "Hapus data");

      var connect =
          Api.connectionApi2("delete", "", "stok-opname-hd/$nomorFaktur", "");
      var getValue = await connect;
      var valueBody = jsonDecode(getValue.body);
      print(valueBody);
      if (valueBody["code"] == 200) {
        UtilsAlert.showToast("Data berhasil di hapus");
        Get.back();
        Get.back();
        Get.back();
        startLoad();
      } else {
        UtilsAlert.showToast("Gagal hapus data");
        Get.back();
        Get.back();
        Get.back();
      }
    });
  }
}
