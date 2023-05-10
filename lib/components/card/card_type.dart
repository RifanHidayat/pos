import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/button/buntton_controller.dart';
import 'package:siscom_pos/utils/utility.dart';

import '../../controller/pelanggan/list_pelanggan_controller.dart';

class CardType {
  static var getcontroller = Get.find<ListPelangganViewController>();

  static memberNonMember(key, {name, point, statusMember, noHp}) {
    return Obx(() => Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: ButtonController.pelangganAktifCard.value == name
                  ? Utility.infoDefault.withOpacity(.1)
                  : Utility.baseColor2,
              border: Border.all(
                  color: ButtonController.pelangganAktifCard.value == name
                      ? Utility.infoDefault
                      : Utility.grey300,
                  width: 0.5)),
          child: ListTile(
            leading: Image.asset(
              "assets/Avatar.png",
              height: 50,
            ),
            title: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                if (key == 'show_data_pelanggan_member_status')
                  Image.asset(
                    "assets/award.png",
                    height: 15,
                  ),
                if (key == 'show_data_pelanggan_member_status')
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      '$point',
                      style: TextStyle(
                        fontSize: Utility.normal,
                      ),
                    ),
                  ),
                if (key == 'show_data_pelanggan_member_status')
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.fiber_manual_record,
                      size: 12,
                      color: Utility.nonAktif,
                    ),
                  ),
                if (key == 'show_data_pelanggan_member_status')
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      statusMember,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Utility.normal,
                      ),
                    ),
                  ),
                if (noHp.isNotEmpty &&
                    key == 'show_data_pelanggan_member_status')
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.fiber_manual_record,
                      size: 12,
                      color: Utility.nonAktif,
                    ),
                  ),
                if (noHp.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      noHp,
                      style: TextStyle(
                        fontSize: Utility.normal,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(
                    color: ButtonController.pelangganAktifCard.value == name
                        ? Utility.infoDefault
                        : Utility.grey300,
                    width: 1),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ButtonController.pelangganAktifCard.value == name
                      ? Utility.infoDefault
                      : Utility.baseColor2,
                ),
              ),
            ),
          ),
        ));
  }
}
