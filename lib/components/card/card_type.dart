import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/utils/utility.dart';

import '../../controller/pelanggan/list_pelanggan_controller.dart';

class CardType {
  static var getcontroller = Get.find<ListPelangganViewController>();

  static memberNonMember({name, point, statusMember, noHp, aktif}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: aktif ? Utility.primaryDefault : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Utility.grey300, width: 0.5)),
      child: ListTile(
        leading: Image.asset(
          "assets/Avatar.png",
          height: 50,
        ),
        title: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: aktif ? Colors.white : Colors.black),
        ),
        subtitle: Row(
          children: [
            Image.asset(
              "assets/award.png",
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3),
              child: Text(
                '$point',
                style: TextStyle(
                    fontSize: Utility.normal,
                    color: aktif ? Colors.white : Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Utility.nonAktif,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3),
              child: Text(
                statusMember,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Utility.normal,
                    color: aktif ? Colors.white : Colors.black),
              ),
            ),
            if (noHp.isNotEmpty)
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
                      color: aktif ? Colors.white : Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
