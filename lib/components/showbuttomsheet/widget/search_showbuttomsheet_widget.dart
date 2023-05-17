import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';

import '../../../controller/pelanggan/list_pelanggan_controller.dart';
import '../../../utils/controllers/controller_implementation.dart';
import '../../../utils/utility.dart';
import '../../../utils/widget/card_custom.dart';

class Search {
  static var controller = TextEditingController();
  static var getcontroller = Get.find<ListPelangganViewController>();
  static var paramimpl = ControllerFindImpl.paramscontrollerimpl;
  static var dashboardcontroller = Get.find<DashbardController>();

  static search(key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CardCustom(
        colorBg: Colors.white,
        radiusBorder: Utility.borderStyle1,
        widgetCardCustom: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 10),
                child: Icon(
                  Iconsax.search_normal_1,
                  size: 18,
                ),
              ),
            ),
            Obx(() => Expanded(
                  flex: 85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 90,
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: "Cari"),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 1.5,
                                    color: Colors.black),
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  getcontroller.search('active');
                                  _validatedsearch(key);
                                },
                                onSubmitted: (value) {
                                  if (controller.text.isNotEmpty) {
                                    getcontroller.search('active');
                                  }
                                },
                              )),
                          if (getcontroller.searchstatus.value == true)
                            Expanded(
                              flex: 15,
                              child: IconButton(
                                icon: Icon(
                                  Iconsax.close_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  controller.clear();
                                  getcontroller.search('close');
                                  if (getcontroller.showmemberstatus.value ==
                                      'member') {
                                    paramimpl.convert(
                                        getcontroller.memberlist.value);
                                  } else {
                                    paramimpl
                                        .convert(getcontroller.nonmemberlist);
                                  }
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  static _validatedsearch(key) {
    switch (key) {
      case 'show_data_pelanggan_member_status':
        if (controller.text.isEmpty) {
          getcontroller.search('close');

          if (getcontroller.showmemberstatus.value == 'member') {
            paramimpl.convert(getcontroller.memberlist.value);
          } else {
            paramimpl.convert(getcontroller.nonmemberlist);
          }
        } else {
          getcontroller.searchdata(controller.text);
          paramimpl.convert(getcontroller.searchmemberlist.value);
        }
        break;
      case 'show_entry_data_sales':
        if (controller.text.isEmpty) {
          getcontroller.search('close');

          paramimpl.convert(dashboardcontroller.listSalesman.value);
        } else {
          dashboardcontroller.salessearch(controller.text);
          paramimpl.convert(dashboardcontroller.searchdataentry.value);
        }
        break;
      case 'show_data_kelompok_barang':
        if (controller.text.isEmpty) {
          getcontroller.search('close');

          paramimpl.convert(dashboardcontroller.listKelompokBarang.value);
        } else {
          dashboardcontroller.kelompokbarangsearch(controller.text);
          paramimpl.convert(dashboardcontroller.searchdataentry.value);
          debugPrint('masuk kesini ');
        }
        break;
      default:
    }
  }
}
