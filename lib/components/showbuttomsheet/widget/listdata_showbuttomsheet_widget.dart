import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/components/card/card_type.dart';
import 'package:siscom_pos/controller/button/buntton_controller.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';

import '../../../controller/penjualan/dashboard_penjualan_controller.dart';
import '../../../controller/pos/dashboard_controller.dart';
import '../../../controller/sidebar_controller.dart';
import '../../../model/params/params_model.dart';
import '../../../utils/controllers/controller_implementation.dart';

class ListData {
  static var getcontroller = Get.find<ListPelangganViewController>();
  static var dashboardController = Get.find<DashbardController>();
  static var dashboardPenjualanCt = Get.find<DashbardPenjualanController>();
  static var sidebarCt = Get.put(SidebarController());

  static Widget list(
    List<ParamsModel> datashow,
    String? key,
  ) {
    return Flexible(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Obx(() => ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: ControllerImpl.paramscontrollerimpl.data.value.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onTap(key, datashow: datashow[index]),
                  child: CardType.memberNonMember(
                    key,
                    name: datashow[index].nama,
                    noHp: datashow[index].nomorTelp,
                    point: datashow[index].point,
                    statusMember: datashow[index].flagmember == 1
                        ? 'Member'
                        : 'Non Member',
                  ),
                );
              })),
        ));
  }

  static _checkingdata({key, nama, kode, wilayah, ppn, charger}) {
    if (key == 'show_data_pelanggan_member_status') {
      getcontroller.pelangganselectedDashboard.value = nama;
    } else if (key == 'show_data_pct_pelanggan_member_status') {
      dashboardPenjualanCt.selectedIdPelanggan.value = kode;
      dashboardPenjualanCt.selectedNamePelanggan.value = nama;
      dashboardPenjualanCt.wilayahCustomerSelected.value = wilayah;
      Get.back();
    } else if (key == 'show_entry_data_sales') {
      dashboardController.pelayanSelected.value = nama;
      dashboardController.kodePelayanSelected.value = kode;
      dashboardController.aksiGetCustomer(kode, '');
    } else if (key == 'show_entry_data_cabang_sidebar') {
      dashboardController.cabangKodeSelected.value = kode;
      dashboardController.cabangNameSelected.value = nama;
      if (ppn != null) {
        dashboardController.ppnCabang.value = double.parse("$ppn");
      }
      if (charger != null) {
        dashboardController.serviceChargerCabang.value =
            double.parse("$charger");
      }
      sidebarCt.cabangKodeSelectedSide.value = kode;
      sidebarCt.cabangNameSelectedSide.value = nama;
      dashboardController.pilihGudang(nama);
      dashboardController.aksiGetSalesman(kode, '', '');
      dashboardController.aksiPilihKategoriBarang();
    } else if (key == 'show_data_kelompok_barang') {
      dashboardController.kategoriBarang.value = nama;
      dashboardController.aksiPilihKategoriBarang();
    }
  }

  static onTap(key, {ParamsModel? datashow}) {
    if (key == 'show_data_pelanggan_member_status') {
      getcontroller.selectednamefun(datashow!.nama);
      ButtonController.setStateBACpelanggan(datashow.nama);
    }
    ButtonController.setStateBACpelanggan(datashow!.nama);
    _checkingdata(
        key: key,
        kode: datashow.kode,
        nama: datashow.nama,
        wilayah: datashow.wilayah,
        ppn: datashow.ppn,
        charger: datashow.charge);
  }
}
