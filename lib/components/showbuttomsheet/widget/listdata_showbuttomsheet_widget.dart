import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/components/card/card_type.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/utils/utility.dart';

import '../../../controller/penjualan/dashboard_penjualan_controller.dart';
import '../../../controller/pos/dashboard_controller.dart';
import '../../../model/params/params_model.dart';
import '../../../utils/controllers/controller_implementation.dart';

class ListData {
  static var getcontroller = Get.find<ListPelangganViewController>();
  static var dashboardController = Get.find<DashbardController>();
  static var dashboardPenjualanCt = Get.find<DashbardPenjualanController>();
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
                  onTap: () {
                    getcontroller.selectednamefun(datashow[index].nama);
                    _checkingdata(
                      key: key,
                      kode: datashow[index].kode,
                      nama: datashow[index].nama,
                      wilayah: datashow[index].wilayah,
                    );
                  },
                  child: CardType.memberNonMember(
                      name: datashow[index].nama,
                      noHp: datashow[index].nomorTelp,
                      point: datashow[index].point,
                      statusMember: datashow[index].flagmember == 1
                          ? 'Member'
                          : 'Non Member',
                      aktif: datashow[index].nama ==
                          getcontroller.selectedname.value),
                );
              })),
        ));
  }

  static _checkingdata({key, nama, kode, wilayah}) {
    if (key == 'show_data_pelanggan_member_status') {
      getcontroller.pelangganselectedDashboard.value = nama;
      Get.back();
    } else if (key == 'show_data_pct_pelanggan_member_status') {
      dashboardPenjualanCt.selectedIdPelanggan.value = kode;
      dashboardPenjualanCt.selectedNamePelanggan.value = nama;
      dashboardPenjualanCt.wilayahCustomerSelected.value = wilayah;
      Get.back();
    }
  }
}
