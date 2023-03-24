import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/model/pelanggan.dart';
import 'package:siscom_pos/model/pelanggan/list_pelanggan_model.dart';
import 'package:siscom_pos/screen/pelanggan/detail_pelanggan_view.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class ListPelangganViewController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: true);

  var sidebarCt = Get.put(SidebarController());

  var listPelanggan = <ListPelangganModel>[].obs;
  var listPelangganMaster = <ListPelangganModel>[].obs;
  var detailPelanggan = <ListPelangganModel>[].obs;

  var pencarian = TextEditingController().obs;

  var screenLoad = false.obs;

  var statusMember = 0.obs;
  var screenDetailAktif = 0.obs;
  var page = 10.obs;

  void startLoad() {
    getProsesListPelanggan();
  }

  Future<bool> getProsesListPelanggan() async {
    var connect = Api.connectionApi2("get", "", "pelanggan",
        "&cabang=${sidebarCt.cabangKodeSelectedSide.value}");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      List<ListPelangganModel> tampungPelanggan = [];
      for (var element in data) {
        tampungPelanggan.add(ListPelangganModel(
          kodePelanggan: element['KODE'],
          namaPelanggan: element['NAMA'],
          namaSales: element['NAMA_SALES'],
          alamat1: element['ALAMAT1'],
          alamat2: element['ALAMAT2'],
          fax: element['FAX'],
          hp: element['HP'],
          email: element['EMAIL'],
          npwp: element['NPWP'],
          wilayah: element['WILAYAH'],
          salesm: element['SALESM'],
          term: "${element['TERM']}",
          limit: Utility.validasiValueDouble("${element['LIMIT']}"),
          sumpd: Utility.validasiValueDouble("${element['SUMPD']}"),
          sumum: Utility.validasiValueDouble("${element['SUMUM']}"),
          batas: Utility.validasiValueDouble("${element['BATAS']}"),
          debe: Utility.validasiValueDouble("${element['DEBE']}"),
          ceer: Utility.validasiValueDouble("${element['CEER']}"),
          kredit: Utility.validasiValueDouble("${element['kredit']}"),
          uangMuka: Utility.validasiValueDouble("${element['uang_muka']}"),
          tanggalLahir: element['TGLLAHIR'],
          tanggalJoin: element['TGLJOIN'],
          tanggalExp: element['TGLEXP'],
          status: element['FLAGMEMBER'],
          nomorTelpon: element['TELP'],
          pointDidapat: Utility.validasiValueDouble("${element['POIND']}"),
          pointDitukar: Utility.validasiValueDouble("${element['POINT']}"),
          totalPoint: Utility.validasiValueDouble("${element['POINK']}"),
        ));
      }
      List<ListPelangganModel> dataMember =
          tampungPelanggan.where((element) => element.status == "Y").toList();
      listPelanggan.value = dataMember;
      listPelangganMaster.value = tampungPelanggan;
      listPelanggan.refresh();
      listPelangganMaster.refresh();
    } else {
      UtilsAlert.showToast("Data tidak di temukan");
    }
    screenLoad.value = true;
    screenLoad.refresh();

    return Future.value(true);
  }

  void detailPelangganView(kode) {
    List<ListPelangganModel> checkDetail = listPelangganMaster
        .where((element) => element.kodePelanggan == kode)
        .toList();
    if (checkDetail.isNotEmpty) {
      detailPelanggan.value = checkDetail;
      detailPelanggan.refresh();
      Get.to(DetailPelangganView(),
          duration: Duration(milliseconds: 350),
          transition: Transition.rightToLeftWithFade);
    }
  }
}
