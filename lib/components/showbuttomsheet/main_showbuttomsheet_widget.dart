import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/components/showbuttomsheet/widget/body_showbuttomsheet_widget.dart';
import 'package:siscom_pos/components/showbuttomsheet/widget/header_showbuttomsheet_widget.dart';
import 'package:siscom_pos/components/showbuttomsheet/widget/listdata_showbuttomsheet_widget.dart';
import 'package:siscom_pos/components/showbuttomsheet/widget/search_showbuttomsheet_widget.dart';
import 'package:siscom_pos/components/showbuttomsheet/widget/show_status_showbottomsheet_widget.dart';
import 'package:siscom_pos/model/params/params_model.dart';
import 'package:siscom_pos/utils/controllers/controller_implementation.dart';

class ButtomSheetImplementation extends GetxController
    with GetTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
    _refrestcontroller();
  }

  _refrestcontroller() {
    ControllerImpl.pelanggancontrollerimpl.refresh();
  }

  build(
      {List<ParamsModel>? list,
      String? judul,
      String? key,
      String? namaSelected}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        transitionAnimationController: AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 500,
          ),
          animationBehavior: AnimationBehavior.normal,
        ),
        context: Get.context!,
        builder: (context) => Body.body(_validasiwidget(
              datalist: list,
              judul: judul,
              key: key,
            )));
  }

  List<Widget> _validasiwidget({key, judul, datalist}) {
    List<Widget> widget = [];
    switch (key) {
      case 'show_data_pelanggan_member_status':
        widget.addAll([
          Header.header(judul),
          Search.search(),
          MemberStatus.memberstatus(),
          ListData.list(datalist, key)
        ]);
        break;
      default:
    }
    return widget;
  }
}
