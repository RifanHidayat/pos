import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/pelanggan/list_pelanggan_controller.dart';
import '../../../utils/controllers/controller_implementation.dart';

import '../../../utils/widget/button.dart';
import '../main_showbuttomsheet_widget.dart';

class MemberStatus {
  static var getcontroller = Get.find<ListPelangganViewController>();
  static var paramimpl = ControllerImpl.paramscontrollerimpl;
  static var buttonsheetimpl = Get.put(ButtomSheetImplementation());

  static Widget memberstatus() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Button1(
              colorBtn: getcontroller.colormemberstatus1.value,
              textBtn: "Member",
              style: 1,
              colorText: getcontroller.colormemberstatus2.value,
              onTap: () {
                paramimpl.convert(getcontroller.memberlist.value);

                getcontroller.validatememberstatus(1);
              },
            )),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Obx(() => Button1(
                colorBtn: getcontroller.colormemberstatus2.value,
                textBtn: "Non Member",
                style: 1,
                colorText: getcontroller.colormemberstatus1.value,
                onTap: () {
                  paramimpl.convert(getcontroller.nonmemberlist.value);
                  getcontroller.validatememberstatus(0);
                },
              )),
        )
      ],
    );
  }
}
