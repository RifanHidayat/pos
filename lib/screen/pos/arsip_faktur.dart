// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/arsip_bt_controller.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ArsipFaktur extends StatefulWidget {
  @override
  _ArsipFakturState createState() => _ArsipFakturState();
}

class _ArsipFakturState extends State<ArsipFaktur> {
  final controller = Get.put(ArsipFakturController());
  var globalController = Get.put(GlobalController());
  var buttomSheetArsip = Get.put(ArsipButtomSheetController());

  late FocusNode myFocusNode;

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    // controller.getMenu("GN.");
  }

  @override
  void initState() {
    controller.getFakturArsip();
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Utility.baseColor2,
          appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 2,
              flexibleSpace: AppbarMenu1(
                title: "Pesanan Tersimpan",
                colorTitle: Utility.primaryDefault,
                colorIcon: Utility.primaryDefault,
                icon: 1,
                onTap: () {
                  Get.back();
                },
              )),
          body: WillPopScope(
            onWillPop: () async {
              Get.back();
              return true;
            },
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    pencarianData(),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Flexible(
                      child: controller.listArsipFaktur.value.isEmpty
                          ? Center(
                              child: Text(controller.loadingString.value),
                            )
                          : listScreenArsip(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pencarianData() {
    return CardCustom(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Iconsax.search_normal_1,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 85,
                      child: TextField(
                        focusNode: myFocusNode,
                        controller: controller.cari.value,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Cari"),
                        style: TextStyle(
                            fontSize: 14.0, height: 1.5, color: Colors.black),
                        onSubmitted: (value) {
                          // controller.cariData(value);
                        },
                      ),
                    ),
                    !controller.statusCari.value
                        ? SizedBox()
                        : Expanded(
                            flex: 15,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.statusCari.value = false;
                                controller.cari.value.text = "";
                                // controller.onReady();
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listScreenArsip() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: controller.listArsipFaktur.value.length,
        itemBuilder: (context, index) {
          var pk = controller.listArsipFaktur.value[index]['PK'];
          var nomor = controller.listArsipFaktur.value[index]['NOMOR'];
          var tanggal = controller.listArsipFaktur.value[index]['TANGGAL'];
          var jam = controller.listArsipFaktur.value[index]['JAM'];
          var keterangan = controller.listArsipFaktur.value[index]['KET1'];
          var statusPaid = controller.listArsipFaktur.value[index]['PAIDPOS'];
          var totalFaktur = controller.listArsipFaktur.value[index]['TOTAL'];
          return InkWell(
            onTap: () {
              buttomSheetArsip.checkDetailTransaksi(pk);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Utility.medium,
                ),
                Text(
                  "$tanggal",
                  style: TextStyle(color: Utility.grey900),
                ),
                SizedBox(
                  height: Utility.small,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 15,
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Utility.grey100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Iconsax.receipt_2,
                              color: Utility.nonAktif,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 55,
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$nomor",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.grey900),
                            ),
                            statusPaid == null
                                ? Container(
                                    child: Text(
                                      "Unpaid",
                                      style: TextStyle(color: Utility.greyDark),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                "${globalController.convertToIdr(totalFaktur, 0)}"),
                            // Text("$totalFaktur"),
                            Text(
                              "$jam",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Utility.grey900,
                                  fontSize: Utility.semiMedium),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }
}
